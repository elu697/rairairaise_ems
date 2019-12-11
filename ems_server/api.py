# -*- coding: utf-8 -*-

from flask import current_app, Flask, redirect, abort, jsonify, make_response, request, send_file
from config.run_config import APP_DEBUG, APP_TESTING
from qrgen import QrGen
import datetime


def logp(p):
    print(p)


def create_app(debug=APP_DEBUG, testing=APP_TESTING, config_overrides=None):
    """

    :param config:
    :param debug:
    :param testing:
    :param config_overrides:
    :return:
    """
    app = Flask(__name__)
    app.debug = debug
    app.testing = testing
    app.config['JSON_AS_ASCII'] = False

    if config_overrides:
        app.config.update(config_overrides)

    @app.route('/api/health')
    def health_check():
        """

        :return:
        """
        response = {
            'status_code': 200,
            'status_msg': 'health is ok',
        }

        return make_response(jsonify(response)), 200

    @app.route('/')
    @app.route('/api')
    def index():
        """

        :return:
        """

        return redirect('/api/health')

    #\@app.errorhandler(204)  # 文章が意味をなしておらず、判定しなかった
    @app.errorhandler(400)  # リクエストが不正である。定義されていないメソッドを使うなど、クライアントのリクエストがおかしい場合に返される。
    @app.errorhandler(401)  # 認証が必要である。Basic認証やDigest認証などを行うときに使用される。
    @app.errorhandler(403)  # 禁止されている。リソースにアクセスすることを拒否された。
    @app.errorhandler(404)  # 未検出。リソースが見つからなかった。
    @app.errorhandler(405)  # 許可されていないメソッド。許可されていないメソッドを使用しようとした。
    @app.errorhandler(406)  # 受理できない。Accept関連のヘッダに受理できない内容が含まれている場合に返される。
    @app.errorhandler(408)  # リクエストタイムアウト。リクエストが時間以内に完了していない場合に返される。
    @app.errorhandler(413)  # ペイロードが大きすぎる。リクエストエンティティがサーバの許容範囲を超えている場合に返す。
    @app.errorhandler(500)  # サーバ内部エラー。サーバ内部にエラーが発生した場合に返される。
    @app.errorhandler(503)  # サービス利用不可。サービスが一時的に過負荷やメンテナンスで使用不可能である。
    def server_error(e):
        """

        :param e:
        :return:
        """

        response = {
            'status_code': int(e.code),
            'status_msg': str(e)
        }

        return make_response(jsonify(response)), e.code

#main api

    @app.route('/api/qr', methods=['GET', 'POST'])
    def get_qr():
        if request.method == 'POST':
            try:
                req = request.get_json()["data"]
                # req = [["test111", "test"]]
                out = QrGen().pdf(req)
            except:
                abort(500)

            filename = "ems_sheet_{0:%Y_%m%d_%H%M_%S}.pdf".format(datetime.datetime.now())
            # response_data = {
            #     'data_count': int(len(req))
            # }

            response = make_response(out)
            response.headers.set('Content-Disposition', 'attachment', filename=filename)
            response.headers.set('Content-Type', 'application/pdf')

            response.mimetype = 'application/pdf'
            return response
        else:
            abort(405)

    return app
