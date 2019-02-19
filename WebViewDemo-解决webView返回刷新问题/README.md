## WebViewDemo

</br>
##### What's Page Cache?
</br>

Pgae Cache store DOM elements, javascript object and other object after webkit render html document.

https://webkit.org/blog/427/webkit-page-cache-i-the-basics/


</br>
##### Do UIWebView have Page Cache ?
</br>

UIWebView have Page Cache, that is include in WebBackForwardList. **BUT** default page cache size in UIWebView is **ZERO**,  that make pageCache disable.
</br>

WKWebView's pageCache is enable default, but WKWebView could **NOT** be hijacked by NSURLProtocol.

</br>
##### How to enable Page Cache ?
</br>

Invoke WebPreferences's _postCacheModelChangedNotification method to post the "WebPreferencesCacheModelChangedInternalNotification" notification, make Page Cache enable.


</br>
##### Problem NOT resolved ?
</br>
I hack UCWeb, find it can hold 5 PageCache in iPhone6 iOS8.4.

But use my method, just 3 page may be cached.
</br>


</br>
My blog about how to find this solution.
[**http://blog.csdn.net/wadahana/article/details/50168643**]
