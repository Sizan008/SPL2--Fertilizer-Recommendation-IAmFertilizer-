from fastapi_mail import FastMail, MessageSchema, ConnectionConfig

conf = ConnectionConfig(
    MAIL_USERNAME="fahimshahryersizan2004@gmail.com",
    MAIL_PASSWORD="yhjg vhju lmwp oxrc", 
    MAIL_FROM="fahimshahryersizan2004@gmail.com",
    MAIL_PORT=587,
    MAIL_SERVER="smtp.gmail.com",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True,
)

async def send_verification_email(email: str, token: str):
    message = MessageSchema(
        subject="Verify your IAmFertilizer Account",
        recipients=[email],
        body=f"""
        <p>Click the link below to verify your account:</p>
        <a href="http://127.0.0.1:8000/auth/verify?token={token}">Verify Email Now</a>
        """,
        subtype="html"
    )
    fm = FastMail(conf)
    await fm.send_message(message)

async def send_reset_password_email(email: str):
    message = MessageSchema(
        subject="Reset Your IAmFertilizer Password",
        recipients=[email],
        body=f"""
        <h3>Password Reset Requested</h3>
        <p>Click the link below to set your new password:</p>
        <a href="http://127.0.0.1:8000/auth/reset-password-page?email={email}">Reset Password Here</a>
        """,
        subtype="html"
    )
    fm = FastMail(conf)
    await fm.send_message(message)