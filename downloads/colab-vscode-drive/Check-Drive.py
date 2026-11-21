"""Read-only mount check, run inside the selected Colab notebook kernel."""
import os

print("COLAB_DRIVE_READY=" + str(int(
    os.path.ismount("/content/drive")
    and os.path.isdir("/content/drive/MyDrive")
)))
