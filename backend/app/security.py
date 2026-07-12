from datetime import datetime, timedelta, timezone
from functools import wraps

import jwt
from flask import current_app, g, request
from werkzeug.security import check_password_hash, generate_password_hash

from . import BusinessError


def hash_password(raw_password: str) -> str:
    return generate_password_hash(raw_password)


def verify_password(raw_password: str, password_hash: str) -> bool:
    return check_password_hash(password_hash, raw_password)


def generate_token(user_id: int, role: str) -> str:
    now = datetime.now(timezone.utc)
    payload = {
        "sub": str(user_id),
        "role": role,
        "iat": int(now.timestamp()),
        "exp": int((now + timedelta(seconds=current_app.config["JWT_EXPIRATION_SECONDS"])).timestamp()),
    }
    return jwt.encode(payload, current_app.config["JWT_SECRET_KEY"], algorithm="HS256")


def decode_token(token: str) -> dict:
    try:
        return jwt.decode(token, current_app.config["JWT_SECRET_KEY"], algorithms=["HS256"])
    except jwt.PyJWTError:
        raise BusinessError("登录状态已失效，请重新登录", code=401, http_status=401)


def current_user_id(required: bool = True) -> int | None:
    header_user_id = request.headers.get("X-User-Id")
    if header_user_id:
        return int(header_user_id)

    auth = request.headers.get("Authorization", "")
    if auth.startswith("Bearer "):
        payload = decode_token(auth[7:])
        return int(payload["sub"])

    if required:
        raise BusinessError("未登录或登录状态已失效", code=401, http_status=401)
    return None


def login_required(view):
    @wraps(view)
    def wrapper(*args, **kwargs):
        g.user_id = current_user_id(required=True)
        return view(*args, **kwargs)

    return wrapper
