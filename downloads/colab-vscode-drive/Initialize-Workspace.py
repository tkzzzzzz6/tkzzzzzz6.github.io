"""Initialize the shared Drive workspace; never replace existing user files."""
import json
import os
import uuid
from pathlib import Path


def initialize_workspace():
    mount = Path("/content/drive")
    my_drive = mount / "MyDrive"
    if not os.path.ismount(mount) or not my_drive.is_dir():
        raise RuntimeError("Google Drive is not mounted. Run colab drivemount first.")

    root = my_drive / "ColabWorkspace"
    link = Path("/content/workspace")
    if link.is_symlink():
        if link.resolve() != root.resolve():
            raise RuntimeError("/content/workspace already points elsewhere; leaving it unchanged.")
    elif link.exists():
        raise RuntimeError("/content/workspace already exists; leaving its contents unchanged.")

    root.mkdir(exist_ok=True)
    for name in ("code", "data", "models", "checkpoints", "outputs", "env"):
        (root / name).mkdir(exist_ok=True)
    marker = root / "env" / "workspace-id.txt"
    try:
        with marker.open("x", encoding="utf-8") as output:
            output.write(str(uuid.uuid4()) + "\n")
    except FileExistsError:
        pass
    workspace_id = str(uuid.UUID(marker.read_text(encoding="utf-8").strip()))
    if not link.is_symlink():
        link.symlink_to(root, target_is_directory=True)

    initial_files = {
        "env/requirements.txt": (
            "# Record your project's Python dependencies here.\n"
            "# Each new Colab VM needs its own package installation.\n"
            "# Example: transformers==<your-tested-version>\n"
        ),
        "env/bootstrap.sh": (
            "#!/usr/bin/env bash\n"
            "set -euo pipefail\n"
            "python -m pip install -r /content/workspace/env/requirements.txt\n"
        ),
        "code/workspace_paths.py": (
            '"""Shared locations, independent of which Colab GPU runs this code."""\n'
            "from pathlib import Path\n\n"
            "ROOT = Path(__file__).resolve().parents[1]\n"
            "DATA = ROOT / 'data'\n"
            "MODELS = ROOT / 'models'\n"
            "CHECKPOINTS = ROOT / 'checkpoints'\n"
            "OUTPUTS = ROOT / 'outputs'\n"
        ),
        "README.txt": (
            "Colab shared workspace\n\n"
            "Persistent root: /content/drive/MyDrive/ColabWorkspace\n"
            "Convenient alias on each prepared VM: /content/workspace\n\n"
            "code/         Project source code\n"
            "data/         Persistent datasets\n"
            "models/       Model weights and adapters\n"
            "checkpoints/  Training checkpoints; use separate subfolders per experiment\n"
            "outputs/      Results, plots, logs and exported models\n"
            "env/          Python dependency list and bootstrap script\n\n"
            "Run the Windows Open-ColabWorkspace.ps1 launcher after creating a new VM.\n"
            "Always authorize the same Google account if Drive prompts for consent.\n"
            "After recording your dependencies, run: bash env/bootstrap.sh\n"
            "Do not share a virtualenv or a live SQLite database between VMs.\n"
            "For training, copy busy datasets to local /content storage when practical.\n"
            "Before switching GPUs, save a complete checkpoint and wait for Drive sync.\n"
            "To resume, point the training framework to that checkpoint directory.\n"
            "Mounting Drive alone does not restore Python packages or training state.\n"
            "Avoid two sessions writing the same checkpoint or model file at once.\n"
        ),
    }
    for relative, content in initial_files.items():
        destination = root / relative
        try:
            with destination.open("x", encoding="utf-8") as output:
                output.write(content)
        except FileExistsError:
            pass

    if not (root / "README.txt").is_file() or link.resolve() != root.resolve():
        raise RuntimeError("Workspace validation failed.")
    print("COLAB_WORKSPACE_READY=1")
    print("COLAB_WORKSPACE_ID=" + workspace_id)
    print(json.dumps({"shared_root": str(root), "shortcut": str(link),
                      "folders": ["code", "data", "models", "checkpoints", "outputs", "env"]}))


initialize_workspace()
