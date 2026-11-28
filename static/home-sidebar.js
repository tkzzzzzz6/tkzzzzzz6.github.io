/* Keep the asynchronously created Live2D canvas inside its homepage sidebar. */
(function () {
    var stage = document.querySelector('.side-live2d-stage');
    if (!stage) return;

    function mount() {
        var widget = document.getElementById('live2d-widget');
        if (!widget) return false;
        stage.appendChild(widget);
        return true;
    }

    if (mount()) return;
    var observer = new MutationObserver(function () {
        if (mount()) observer.disconnect();
    });
    // Keep observing through BFCache suspension until the model is created.
    observer.observe(document.body, { childList: true });
})();
