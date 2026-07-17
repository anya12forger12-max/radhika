# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | ✅ Supported       |

## Reporting a Vulnerability

Please report security vulnerabilities to the repository administrator. Do not create public issues for security vulnerabilities.

## Security Measures

- All data encrypted in transit (HTTPS/TLS)
- Firebase Authentication with email/password and Google Sign-In
- Firestore Security Rules prevent cross-user data access
- Local data encrypted using platform secure storage
- Input validation on all user inputs
- Session management with token refresh
- Crash logs do not contain sensitive user information
- Code obfuscation enabled in release builds

## Best Practices

1. Never commit API keys or secrets to the repository
2. Use environment variables for configuration
3. Keep dependencies updated
4. Follow the principle of least privilege
5. Regular security audits of Firestore rules
