import CCurl
import Foundation

enum CCurlError: Error {
    case InitError, PerformError
}

print("Successfully imported CCurl")

guard let curl = curl_easy_init() else {
    print("curl could no be initialised!")
    throw CCurlError.InitError
}
print("Successfully inited curl")

curlHelperSetOptString(curl, CURLOPT_URL, "https://requestb.in/p8pkjap8")
curlHelperSetOptString(curl, CURLOPT_POSTFIELDS, "fizz=buzz")

let resultCode = curl_easy_perform(curl)
if resultCode != CURLE_OK {
    print("something went wrong: " + String(describing: curl_easy_strerror(resultCode)))
}

curl_easy_cleanup(curl);