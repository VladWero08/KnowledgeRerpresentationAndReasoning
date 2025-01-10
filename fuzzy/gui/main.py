import webview
from api import API

def main():
    # create an instance of the API
    api = API()
    
    # create the webview window
    webview.create_window(
        title='PyWebView Form',
        html=api.html,
        js_api=api
    )
    
    # start the webview event loop
    webview.start()

if __name__ == '__main__':
    main()