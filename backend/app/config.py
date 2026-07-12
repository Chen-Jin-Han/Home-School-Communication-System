import os


class BaseConfig:
    SECRET_KEY = os.getenv("APP_SECRET_KEY", "hwadee-fsc-dev-secret")
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "hwadee-fsc-jwt-secret-key-2026-please-change")
    JWT_EXPIRATION_SECONDS = int(os.getenv("JWT_EXPIRATION_SECONDS", "86400"))
    SQLALCHEMY_DATABASE_URI = os.getenv(
        "DATABASE_URL",
        "mysql+pymysql://root:root@127.0.0.1:3306/hwadee_fsc?charset=utf8mb4",
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {
        "pool_pre_ping": True,
        "pool_recycle": 280,
        "pool_size": int(os.getenv("DB_POOL_SIZE", "10")),
        "max_overflow": int(os.getenv("DB_MAX_OVERFLOW", "20")),
    }
    CORS_ORIGINS = os.getenv("CORS_ORIGINS", "*")
    AUTO_INIT_DB = os.getenv("AUTO_INIT_DB", "true").lower() == "true"


class DevelopmentConfig(BaseConfig):
    DEBUG = True


class TestingConfig(BaseConfig):
    TESTING = True
    AUTO_INIT_DB = True
    SQLALCHEMY_DATABASE_URI = os.getenv("TEST_DATABASE_URL", "sqlite:///:memory:")
    SQLALCHEMY_ENGINE_OPTIONS = {}


class ProductionConfig(BaseConfig):
    DEBUG = False


def get_config(config_name: str | None = None):
    env = config_name or os.getenv("FLASK_ENV", "production")
    return {
        "development": DevelopmentConfig,
        "testing": TestingConfig,
        "production": ProductionConfig,
    }.get(env, ProductionConfig)
