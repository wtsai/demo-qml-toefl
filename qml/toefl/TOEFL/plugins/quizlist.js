
//http://localhost:3000/apis/quiz/16/5
var ipaddress = "http://192.168.2.126:9000"
var router = "/apis/quiz"
var json;
var quiz_index = 0;
var json_index = 0;
var skip = 0;
var count = 20;
var doc = new XMLHttpRequest();

function load(){
    var now = new Date();
    var seed = now.getSeconds();
    var num = (Math.floor(count * Math.random(seed)));
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
            console.log("[HEADERS_RECEIVED]!!!");

        } else if (doc.readyState == XMLHttpRequest.DONE) {
            json = JSON.parse(doc.responseText.toString());
            console.log("[load]index: " + json_index + ";[load]num: " + num);
            if ((json_index+num) % count == json_index )
            {
                num += 5;
                num %=count;
                console.log("[load]index: " + json_index + ";[load]num: " + num);
            }

            quizModel.append({
                  "English": json['quiz'][json_index]['word'],
                  "OptionA": json['quiz'][json_index]['chinese'],
                  "OptionB": json['quiz'][(json_index+num) % count]['chinese'],
                  "Answer": 'OptionA'
            });
            json_index += 1;
        }
    }

    doc.open("GET", ipaddress + router + "/" + skip + "/" + count);
    doc.send();

}

function loaded(status){
    var now = new Date();
    var seed = now.getSeconds();
    var num = (Math.floor(count * Math.random(seed)));

    console.log("[loaded]status: " + status + ";[loaded]index: " + json_index + ";[loaded]num: " + num);
    if (status == "error")
    {
        json_index -= 1;
    }
    if ((json_index+num) % count == json_index )
    {
        num += 5;
        num %=count;
        console.log("[loaded]status: " + status + ";[loaded]index: " + json_index + ";[loaded]num: " + num);
    }
    switch(num % 2) {
        case 0:
            quizModel.append({
                  "English": json['quiz'][json_index]['word'],
                  "OptionA": json['quiz'][json_index]['chinese'],
                  "OptionB": json['quiz'][(json_index+num) % count]['chinese'],
                  "Answer": 'OptionA'
            });
            break;
        case 1:
            quizModel.append({
                  "English": json['quiz'][json_index]['word'],
                  "OptionA": json['quiz'][(json_index+num) % count]['chinese'],
                  "OptionB": json['quiz'][json_index]['chinese'],
                  "Answer": 'OptionB'
            });
            break;
    }
    json_index += 1;
    if ((skip+count) == json_index )
    {
        skip = skip+count;
        count = 50;
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
                console.log("[HEADERS_RECEIVED]!!!");

            } else if (doc.readyState == XMLHttpRequest.DONE) {
                json = JSON.parse(doc.responseText.toString());
                console.log("[load]index: " + json_index + ";[load]num: " + num);
                if ((json_index+num) % count == json_index )
                {
                    num += 5;
                    num %=count;
                    console.log("[load]index: " + json_index + ";[load]num: " + num);
                }

                quizModel.append({
                      "English": json['quiz'][json_index]['word'],
                      "OptionA": json['quiz'][json_index]['chinese'],
                      "OptionB": json['quiz'][(json_index+num) % count]['chinese'],
                      "Answer": 'OptionA'
                });
                json_index += 1;
            }
        }

        doc.open("GET", ipaddress + router + "/" + skip + "/" + count);
        doc.send();
    }
}
