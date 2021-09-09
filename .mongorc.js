// save as .mongorc.js

host = db.serverStatus().host.match(/^([^.]+)/)[0]
user = db.runCommand({connectionStatus : 1}).authInfo.authenticatedUsers[0].user
prompt = function() { return user + "@" + host + ":" + db + "> " }

function ToGUID(hex) {
    var a = hex.substr(6, 2) + hex.substr(4, 2) + hex.substr(2, 2) + hex.substr(0, 2);
    var b = hex.substr(10, 2) + hex.substr(8, 2);
    var c = hex.substr(14, 2) + hex.substr(12, 2);
    var d = hex.substr(16, 16);
    var hex2 = a + b + c + d;
    var uuid = hex2.substr(0, 8) + '-' + hex2.substr(8, 4) + '-' + hex2.substr(12, 4) + '-' + hex2.substr(16, 4) + '-' + hex2.substr(20, 12);
    return '"' + uuid + '"';
}

function FromGUID(hex) {
    var uuid = hex.substr(6, 2) + hex.substr(4, 2) + hex.substr(2, 2) + hex.substr(0, 2) +
            hex.substr(11, 2) + hex.substr(9, 2) +
            hex.substr(16, 2) + hex.substr(14, 2) +
            hex.substr(19, 4) + hex.substr(24, 12);
    return HexData(3, uuid);
}

function showTokens(collection={}) {
    db.UserDevices.find(collection).forEach(
        function(myDoc) {
            print(
                "Id:", ToGUID(myDoc.Id.hex()) + ":\n  ",
                "TenantId:", ToGUID(myDoc.TenantId.hex()) + "\n  ",
                "UserID:", ToGUID(myDoc.UserId.hex()) + "\n  ",
                "DeviceType:", myDoc.DeviceType + "\n  ",
                "RegistrationDateUtc:", myDoc.RegistrationDateUtc + "\n  ",
                "Token:", myDoc.FcmToken + "\n"
            )
        }
    )
}
