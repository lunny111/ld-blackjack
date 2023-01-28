const registered = [];

function RegisterUICallback(name, cb) {
    AddEventHandler(`_npx_uiReq:${name}`, cb);

    if (GetResourceState('ld-ui') === 'started') exports['ld-ui'].RegisterUIEvent(name);

    registered.push(name);
}

function SendUIMessage(data) {
    exports['ld-ui'].SendUIMessage(data);
}

function SetUIFocus(hasFocus, hasCursor) {
    exports['ld-ui'].SetUIFocus(hasFocus, hasCursor);
}

function GetUIFocus() {
    return exports['ld-ui'].GetUIFocus();
}

AddEventHandler('_npx_uiReady', () => {
    registered.forEach((eventName) => exports['ld-ui'].RegisterUIEvent(eventName));
});