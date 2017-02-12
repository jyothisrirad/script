#!/usr/bin/env python

from flask import Flask, request, abort

from linebot import (
    LineBotApi, WebhookHandler
)
from linebot.exceptions import (
    InvalidSignatureError
)
from linebot.models import (
    MessageEvent, TextMessage, TextSendMessage,
)

app = Flask(__name__)

line_bot_api = LineBotApi('SFS/GctoxEUeF+AwFdqETwRkIIvxajJsnwX1EUz7owLpAyGa/X4qeTfzVZABlR30jf16AVyTH5HMCJhYY/H7zALkFibq8c839jzfilIG/41re6yLy7a1Ia1RhxFG3t8Ea+rzTWkV7ESOUnIglfUTdQdB04t89/1O/w1cDnyilFU=')
handler = WebhookHandler('8df6678d1f2a125162a123f3327e95fb')


@app.route("/callback", methods=['POST'])
def callback():
    # get X-Line-Signature header value
    signature = request.headers['X-Line-Signature']

    # get request body as text
    body = request.get_data(as_text=True)
    app.logger.info("Request body: " + body)

    # handle webhook body
    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        abort(400)

    return 'OK'


@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    line_bot_api.reply_message(
        event.reply_token,
        TextSendMessage(text=event.message.text))

@handler.default()
def default(event):
    print(event)

if __name__ == "__main__":
    app.run()

