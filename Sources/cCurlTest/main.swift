import CCurl
import Foundation

enum CCurlError: Error {
    case InitError
    case HeaderError
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

// set url
curlHelperSetOptString(curl, CURLOPT_URL, serverUrl)

// set post true
curlHelperSetOptBool(curl, CURLOPT_POST, CURL_TRUE)

// set headers
var headers = curl_slist_append(nil, "Content-Type: application/json")
headers = curl_slist_append(headers, "charsets: utf-8")
curlHelperSetOptList(curl, CURLOPT_HTTPHEADER, headers)

// set post data
// curlHelperSetOptString(curl, CURLOPT_POSTFIELDS, postData)

let postDataUtf8 = postData.utf8CString // it's important to cache this before the closure
postDataUtf8.withUnsafeBufferPointer { ptr in
    curlHelperSetOptString(curl, CURLOPT_POSTFIELDS, ptr.baseAddress)
}

// get verbose debug output
curlHelperSetOptBool(curl, CURLOPT_VERBOSE, CURL_TRUE)

print("Performing request...")

let resultCode = curl_easy_perform(curl)
if resultCode != CURLE_OK {
    print("something went wrong: " + String(describing: curl_easy_strerror(resultCode)))
}

curl_slist_free_all(headers); /* free the list again */
curl_easy_cleanup(curl)
