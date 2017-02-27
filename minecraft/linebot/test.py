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

from linebot.exceptions import LineBotApiError



app = Flask(__name__)

line_bot_api = LineBotApi('SFS/GctoxEUeF+AwFdqETwRkIIvxajJsnwX1EUz7owLpAyGa/X4qeTfzVZABlR30jf16AVyTH5HMCJhYY/H7zALkFibq8c839jzfilIG/41re6yLy7a1Ia1RhxFG3t8Ea+rzTWkV7ESOUnIglfUTdQdB04t89/1O/w1cDnyilFU=')

print dir(line_bot_api)
print line_bot_api


handler = WebhookHandler('8df6678d1f2a125162a123f3327e95fb')

print WebhookHandler

try:
    profile = line_bot_api.get_profile('@ncb6055r')
    print(profile.display_name)
    print(profile.user_id)
    print(profile.picture_url)
    print(profile.status_message)
except LineBotApiError as e:
    import traceback
    # error handle
    traceback.print_exc()
    print(e.status_code)
    print(e.error.message)
    print(e.error.details)

