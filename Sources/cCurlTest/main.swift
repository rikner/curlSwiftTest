import CCurl
import Foundation

enum CCurlError: Error {
    case InitError
}

// var read_callback: (@convention(c)
// (UnsafeMutablePointer<Int8>?, Int, Int, UnsafeMutableRawPointer?) -> Int)! = { dest, size, nmemb, userp in
//     print("read callback is executed")
//     return 0
// }

guard let curl = curl_easy_init() else {
    print("curl could no be initialised!")
    throw CCurlError.InitError
}

let serverUrl =  "http://192.168.1.10:3000/graphql"
let postData = """
{
	"query": "query SingleSong($songId: ID!) { song(songId: $songId) { _id } }",
	"variables": {
		"songId": "AqpMMhAgBvw4u9qsu"
	}
}
"""


curlHelperSetOptString(curl, CURLOPT_URL, serverUrl)
curlHelperSetOptString(curl, CURLOPT_POSTFIELDS, postData)

/* we want to use our own read function */ 
// curlHelperSetOptReadFunc(curl, nil, read_callback)

var headers = curl_slist_append(nil, "Content-Type: application/json")
curlHelperSetOptList(curl, CURLOPT_HTTPHEADER, headers)

/* get verbose debug output please */ 
curlHelperSetOptBool(curl, CURLOPT_VERBOSE, CURL_TRUE)

// headers.deallocate(capacity: 1)

print("Performing request...")

let resultCode = curl_easy_perform(curl)
if resultCode != CURLE_OK {
    print("something went wrong: " + String(describing: curl_easy_strerror(resultCode)))
}

curl_easy_cleanup(curl)

