function CallApp(name, params, callback) {
    if (params == null) {
        params = {}
    }
    let data = {
        name: name,
        params: params,
        callback: null
    };
    if (callback != null) {
        var callback_name = 'C' + Math.random().toString(36).substr(2);
        window[callback_name] = function(obj) {
            callback(obj);
            delete window[callback_name]
        };
        data.callback = callback_name
    }
    window.webkit.messageHandlers.call.postMessage(JSON.stringify(data));
}

function OpenCamera() {
    CallApp('CameraOpen', {}, function(data) {
        document.getElementById("myImg").setAttribute('src', 'data:image/png;base64,' + data);
    });
}

function OpenAlbum() {
    CallApp('AlbumOpen', {}, function(data) {
        document.getElementById("myImg").setAttribute('src', 'data:image/png;base64,' + data);
    });
}


function ShowToast() {
    var toastText = document.getElementById("toast").value;
    CallApp('ToastShow', {
        name: toastText
        }, function(data) {
        console.log(data);
    });
}

function SaveData() {
    var name = document.getElementById("dataSaveKey").value;
    var value = document.getElementById("dataSave").value;
    CallApp('DataSave', {
        name: name,
        value: value
    }, function(data) {
        console.log(data);
    });
}

function GetData() {
    var name = document.getElementById("dataGet").value;
    CallApp('DataGet', {
        name: name
    }, function(data) {
        console.log(data);
    });
}

function CallPhone() {
    var name = document.getElementById("phoneCall").value;
    CallApp('CallPhone', {
        name: name
    }, function(data) {
        console.log(data);
    });
}
