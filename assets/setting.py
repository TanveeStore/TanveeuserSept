"""
Django settings for tanvee project.

Generated by 'django-admin startproject' using Django 3.2.11.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/3.2/ref/settings/
"""

import os
from pathlib import Path
from datetime import timedelta
from corsheaders.defaults import default_headers
os.environ["PATH"] += os.pathsep + "/usr/bin/dot"

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent
# BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-*lehtj69b06uivorkny7d*4%650(oc^kn3d_q@4vb067fta5a9'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['34.100.212.22','tanveestore.com', 'localhost']


# Application definition

INSTALLED_APPS = [
    # Django admin Customization library. third Party Library.
    'jazzmin',
    # my apps
    # add your apps which you create using manage.py startapp
    'common',
    'Notifications',
    'Dashboard',
    'products',
    'CartSystem',
    'orders',
    'Review',
    'Offers',
    'vendor',
    'deliveryExecutive',
    'checkout',


    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # third_party_apps
    # add apps which you install using pip
    "rest_framework",
    'rest_framework_simplejwt',
    'rest_framework_simplejwt.token_blacklist',
    'corsheaders',
    'phonenumber_field',
    'ckeditor',
    'django_filters',
    'django_extensions',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
]

ROOT_URLCONF = 'tanvee.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'tanvee.wsgi.application'


# Database
# https://docs.djangoproject.com/en/3.2/ref/settings/#databases

# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.sqlite3',
#         'NAME': BASE_DIR / 'db.sqlite3',
#     }
# }

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'testtanvee1',
        'USER': 'root',
        'PASSWORD': '',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}


# Password validation
# https://docs.djangoproject.com/en/3.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/3.2/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'Asia/Kolkata'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.2/howto/static-files/


STATIC_URL = '/static/'
STATIC_ROOT = '/django-project/site/public/static'

MEDIA_URL = '/media/'
MEDIA_ROOT = '/django-project/site/public/media'


# STATIC_DIR = os.path.join(BASE_DIR, 'static')

# STATIC_ROOT = os.path.join(BASE_DIR, 'static')
# STATIC_URL = '/static/'

# MEDIA_ROOT = os.path.join(BASE_DIR, 'uploads')
# MEDIA_URL = '/files/'

# Default primary key field type
# https://docs.djangoproject.com/en/3.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


REST_FRAMEWORK = {

    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    )
}


SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=180),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=180),

    'AUTH_HEADER_TYPES': ('Bearer',),
    'AUTH_HEADER_NAME': 'HTTP_AUTHORIZATION',
    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',
    'USER_AUTHENTICATION_RULE': 'rest_framework_simplejwt.authentication.default_user_authentication_rule',

    'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
    'TOKEN_TYPE_CLAIM': 'token_type',
    'TOKEN_USER_CLASS': 'rest_framework_simplejwt.models.TokenUser',

    'JTI_CLAIM': 'jti',

}

CORS_ALLOW_HEADERS = default_headers
CORS_ORIGIN_ALLOW_ALL = True

AUTH_USER_MODEL = 'common.User'

APPLICATION_NAME = "Tanvee"

SETTINGS_EXPORT = ["APPLICATION_NAME"]

# CKEditor
CKEDITOR_CONFIGS = {
    'default': {
        'width': 'unset',
        'height': 'unset',
    }
}

CKEDITOR_ALLOW_NONIMAGE_FILES = False
CKEDITOR_UPLOAD_PATH = "uploads/"

# System
MULTI_VENDOR = True   # False
ADD_TO_CART_WITHOUT_LOGIN = False   # True

# If you have additional data for user
HAS_ADDITIONAL_USER_DATA = True   # False
# Without additional data, user cannot go to other routes.
# If True, multi step sign up case.
MUST_HAVE_ADDITIONAL_DATA = True    # False
DISPLAY_OUT_OF_STOCK_PRODUCTS = True    # False


EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_HOST_USER = 'developer.akash09@gmail.com'
EMAIL_HOST_PASSWORD = 'xbpyehcambtqlauv'
# EMAIL_HOST_USER = 'dev.rachhel@gmail.com'
# EMAIL_HOST_PASSWORD = 'Rachhel@1998'
EMAIL_USE_TLS = True

## personal
# RAZORPAY_API_KEY = 'rzp_test_xGrQHFJAeQY8uD'
# RAZORPAY_API_SECRET_KEY = 'Al9j2AxxhmlYv6uPiG3iYwii'


# ## client TestMode Key
# RAZORPAY_API_KEY = 'rzp_test_EK1Fh8he18fUGa'
# RAZORPAY_API_SECRET_KEY = 'rCOTEgmuHPo3QDRtUBoUkUmt'


# client LiveMode Key and Secret key
RAZORPAY_API_KEY = 'rzp_live_3rG4OQtcjC1WS3'
RAZORPAY_API_SECRET_KEY = 'v7HbtrpAyq4KgYsmIxlYNa24'


GRAPH_MODELS = {
  'all_applications': True,
  'group_models': True,
}


JAZZMIN_SETTINGS = {
    # title of the window (Will default to current_admin_site.site_title if absent or None)
    # "site_title": "Library Admin",

    # Title on the login screen (19 chars max) (defaults to current_admin_site.site_header if absent or None)
    # "site_header": "Library",

    # Title on the brand (19 chars max) (defaults to current_admin_site.site_header if absent or None)
    # "site_brand": "Library",

    # # Logo to use for your site, must be present in static files, used for brand on top left
    # "site_logo": "/django-project/site/public/static/website/assets/img/home-4-img/logo-4.png",

    # # Logo to use for your site, must be present in static files, used for login form logo (defaults to site_logo)
    # "login_logo": "/django-project/site/public/static/website/assets/img/home-4-img/logo-4.png",

    # # Logo to use for login form in dark themes (defaults to login_logo)
    # "login_logo_dark": None,

}