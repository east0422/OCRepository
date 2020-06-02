function test() {
    ocmsgHandler.test();
}

function choosePicFromAlbum() {
    ocmsgHandler.choosePicFromAlbum(function(data) {
        document.getElementById("myImg2").setAttribute('src', 'data:image/png;base64,' + data);
    });
}

