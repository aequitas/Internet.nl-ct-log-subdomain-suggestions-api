"""
Django settings for app project.

Generated by 'django-admin startproject' using Django 4.2.2.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/4.2/ref/settings/
"""

import os
import time
from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY: str = os.environ.get("SECRET_KEY", "_dzlo^9d#ox6!7c9rju@=u8+4^sprqocy3s*l*ejc2yr34@&98")

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = [
    "ctlssa.suggestions",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "ctlssa.app.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "ctlssa.app.wsgi.application"


# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases
DATABASE_OPTIONS = {}

DB_ENGINE = os.environ.get("CTLSSA_DB_ENGINE", "postgresql")
DATABASE_ENGINES = {"postgresql": "django.db.backends.postgresql"}

DATABASES_SETTINGS = {
    # persist local database used during development
    "dev": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": os.environ.get("CTLSSA_DB_NAME", "db.sqlite3"),
    },
    # sqlite memory database for running tests without storing them permanently
    "test": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": os.environ.get("CTLSSA_DB_NAME", "db.sqlite3"),
    },
    # for production get database settings from environment (eg: docker)
    "production": {
        "ENGINE": DATABASE_ENGINES.get(DB_ENGINE, f"django.db.backends.{DB_ENGINE}"),
        "NAME": os.environ.get("CTLSSA_DB_NAME", "ctlssa"),
        "USER": os.environ.get("CTLSSA_DB_USER", "ctlssa"),
        "PASSWORD": os.environ.get("CTLSSA_DB_PASSWORD", "ctlssa"),
        "HOST": os.environ.get("CTLSSA_DB_HOST", "postgresql"),
        "OPTIONS": DATABASE_OPTIONS.get(os.environ.get("CTLSSA_DB_ENGINE", "postgresql"), {}),
    },
}
# allow database to be selected through environment variables
DATABASE = os.environ.get("CTLSSA_DJANGO_DATABASE", "dev")
DATABASES = {"default": DATABASES_SETTINGS[DATABASE]}


# Password validation
# https://docs.djangoproject.com/en/4.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


# Internationalization
# https://docs.djangoproject.com/en/4.2/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.2/howto/static-files/

STATIC_URL = "static/"

# Default primary key field type
# https://docs.djangoproject.com/en/4.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# .an has been dissolved, but this page lists the other options: https://en.wikipedia.org/wiki/.an
# .nl is managed by the SIDN and is the domain of the Netherlands.
# .aw, .cw, .sr, .sx, .bq are the special municipalities and countries within the kingdom of the Netherlands.
# .frl is a province with their own recognized language
# .amsterdam is the capitcal city of the Netherlands which provides this extension
ACCEPTED_TLDS = os.environ.get("CTLSSA_ACCEPTED_TLDS", "nl,aw,cw,sr,sx,bq,frl,amsterdam,politie")
ACCEPTED_TLDS = ACCEPTED_TLDS.split(",")

if not ACCEPTED_TLDS:
    print(
        "Warning: no filter set on ACCEPTED_TLDS, will try to import all subdomains of everything to the database. "
        "This tool has not been developed for this use case and might not perform well with this amount of data. "
    )
    print("This script will continue in 10 seconds. We're excited how far this solution scaled for you. For science!")
    time.sleep(10)

DEQUE_LENGTH = os.environ.get("CTLSSA_DEQUE_LENGTH", 10000)

CERTSTREAM_SERVER_URL = os.environ.get("CTLSSA_CERTSTREAM_SERVER_URL", "wss://certstream.calidog.io/")

# when reading the .com zone or something else ridiculously large, increase this value to reduce the number of
# database round trips. This number is fine for the nl zone.
AUTO_WRITE_BATCH_SIZE = os.environ.get("CTLSSA_AUTO_WRITE_BATCH_SIZE", 2000)


LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",  # sys.stdout
            "formatter": "color",
        },
    },
    "formatters": {
        "debug": {
            "format": "%(asctime)s\t%(levelname)-8s - %(filename)-20s:%(lineno)-4s - " "%(funcName)20s() - %(message)s",
        },
        "color": {
            "()": "colorlog.ColoredFormatter",
            # to get the name of the logger a message came from, add %(name)s.
            "format": "%(log_color)s%(asctime)s\t%(levelname)-8s - " "%(message)s",
            "datefmt": "%Y-%m-%d %H:%M:%S",
            "log_colors": {
                "DEBUG": "green",
                "INFO": "white",
                "WARNING": "yellow",
                "ERROR": "red",
                "CRITICAL": "bold_red",
            },
        },
    },
    "loggers": {
        "django": {
            "handlers": ["console"],
            "level": os.getenv("CTLSSA_DJANGO_LOG_LEVEL", "INFO"),
        },
        "ctlssa.app": {
            "handlers": ["console"],
            "level": os.getenv("CTLSSA_APP_LOG_LEVEL", "DEBUG"),
        },
        "ctlssa.suggestions": {
            "handlers": ["console"],
            "level": os.getenv("CTLSSA_SUGGESTIONS_LOG_LEVEL", "DEBUG"),
        },
    },
}
