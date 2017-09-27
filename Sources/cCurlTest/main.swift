import CCurl
import Foundation

extension String: Error {}

// var read_callback: (@convention(c)
// (UnsafeMutablePointer<Int8>?, Int, Int, UnsafeMutableRawPointer?) -> Int)! = { dest, size, nmemb, userp in
//     print("read callback is executed")
//     return 0
// }

guard let curl = curl_easy_init() else {
    print("curl could no be initialised!")
    throw "Error during curl init"
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

// set post to true
curlHelperSetOptBool(curl, CURLOPT_POST, CURL_TRUE)

// set headers
var headers = curl_slist_append(nil, "Content-Type: application/json")
headers = curl_slist_append(headers, "charsets: utf-8")
curlHelperSetOptList(curl, CURLOPT_HTTPHEADER, headers)

// set post data
let postDataUtf8 = postData.utf8CString // it's important to cache this before the closure
postDataUtf8.withUnsafeBufferPointer { ptr in
    curlHelperSetOptString(curl, CURLOPT_POSTFIELDS, ptr.baseAddress)
}

// set verbose debug output to true
curlHelperSetOptBool(curl, CURLOPT_VERBOSE, CURL_TRUE)

// perform request
let resultCode = curl_easy_perform(curl)
if resultCode != CURLE_OK {
    print("something went wrong: " + String(describing: curl_easy_strerror(resultCode)))
}

curl_slist_free_all(headers)
curl_easy_cleanup(curl)
