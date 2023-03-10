var IotApi = require('@arduino/arduino-iot-client');
var rp = require('request-promise');

async function getToken() {
    var options = {
        method: 'POST',
        url: 'https://api2.arduino.cc/iot/v1/clients/token',
        headers: { 'content-type': 'application/x-www-form-urlencoded' },
        json: true,
        form: {
            grant_type: 'client_credentials',
            client_id: '11BPBTVoGudlcJ8408X6HpTLYXGyEuJ1',
            client_secret: 'XJJ1N3B1BpggeI5qSpF3K3t6kYSa482Ry2lNe7ofcA0o71hTpIqgh1Nn883IHnIs',
            audience: 'https://api2.arduino.cc/iot'
        }
    };

    try {
        const response = await rp(options);
        return response['access_token'];
    }
    catch (error) {
        console.error("Failed getting an access token: " + error)
    }
}

async function run() {
    var client = IotApi.ApiClient.instance;
    // Configure OAuth2 access token for authorization: oauth2
    var oauth2 = client.authentications['oauth2'];
    oauth2.accessToken = await getToken();

    var api = new IotApi.DevicesV2Api(client)
    api.devicesV2List().then(devices => {
        console.log(devices);
    }, error => {
        console.log(error)
    });
}

run();