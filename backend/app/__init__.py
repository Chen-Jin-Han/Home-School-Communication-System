from flask import Flask, jsonify
from werkzeug.exceptions import HTTPException


class BusinessError(Exception):
    def __init__(self, message: str, code: int = 1000, http_status: int = 200):
        super().__init__(message)
        self.message = message
        self.code = code
        self.http_status = http_status


from .config import get_config
from .extensions import cors, db, migrate
from .routes import api_bp
from .seed import ensure_schema, seed_data


def create_app(config_name: str | None = None) -> Flask:
    app = Flask(__name__)
    app.config.from_object(get_config(config_name))

    db.init_app(app)
    migrate.init_app(app, db)
    cors.init_app(app, resources={r"/*": {"origins": app.config["CORS_ORIGINS"]}})

    app.register_blueprint(api_bp)

    register_error_handlers(app)

    if app.config["AUTO_INIT_DB"]:
        with app.app_context():
            db.create_all()
            ensure_schema()
            seed_data()

    return app


def register_error_handlers(app: Flask) -> None:
    @app.errorhandler(BusinessError)
    def handle_business_error(error: BusinessError):
        return jsonify({"code": error.code, "message": error.message, "data": None}), error.http_status

    @app.errorhandler(HTTPException)
    def handle_http_error(error: HTTPException):
        return jsonify({"code": error.code or 500, "message": error.description, "data": None}), error.code

    @app.errorhandler(Exception)
    def handle_unexpected_error(error: Exception):
        app.logger.exception("Unhandled backend error")
        return jsonify({"code": 500, "message": "服务器内部错误", "data": None}), 500
