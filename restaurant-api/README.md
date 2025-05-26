# Restaurant Backend

This is the backend component of the Restaurant application, built with Symfony and API Platform.

## Technologies

- **PHP 8.x**
- **Symfony 6.x**
- **API Platform** - REST API framework
- **Doctrine ORM** - Database abstraction
- **Lexik JWT** - Authentication
- **Nelmio CORS** - Cross-Origin Resource Sharing support

## Setup

### Prerequisites

- PHP 8.0 or higher
- Composer
- Database (MySQL)
- Symfony CLI (optional, for development)

### Installation

1. Clone the repository
2. Navigate to the backend directory:
   ```
   cd Restaurant/restaurant-api
   ```
3. Install dependencies:
   ```
   composer install
   ```
4. Set up your environment variables by creating a `.env.local` file:
   ```
   DATABASE_URL="mysql://db_user:db_password@127.0.0.1:3306/db_name"
   JWT_SECRET_KEY=%kernel.project_dir%/config/jwt/private.pem
   JWT_PUBLIC_KEY=%kernel.project_dir%/config/jwt/public.pem
   JWT_PASSPHRASE=your_passphrase
   ```
5. Generate JWT keys:
   ```
   php bin/console lexik:jwt:generate-keypair
   ```

   If you encounter an error, try the manual approach:
   ```
   mkdir -p config/jwt
   openssl genpkey -algorithm RSA -out config/jwt/private.pem -pkeyopt rsa_keygen_bits:4096
   openssl rsa -pubout -in config/jwt/private.pem -out config/jwt/public.pem
   ```
6. Create the database and run migrations:
   ```
   php bin/console doctrine:database:create
   php bin/console doctrine:migrations:migrate
   ```
7. Load fixtures (optional, for development data):
   ```
   php bin/console doctrine:fixtures:load
   ```

### Running the Application

For development:
```
symfony server:start
```
Or without Symfony CLI:
```
php -S localhost:8000 -t public/
```

## API Documentation

Once the server is running, you can access the API documentation at:

- Swagger UI: `http://localhost:8000/api/docs`
- ReDoc: `http://localhost:8000/api/docs?ui=re_doc`

## Authentication

This API uses JWT authentication. To obtain a token:

```
POST /api/login_check
Content-Type: application/json

{
  "username": "your-username",
  "password": "your-password"
}
```

Then use the token in subsequent requests:

```
Authorization: Bearer {token}
```

## Development

### Creating a New Entity

```
php bin/console make:entity
```

### Creating a Migration

After changing entities:

```
php bin/console make:migration
php bin/console doctrine:migrations:migrate
```

### Running Tests

```
php bin/phpunit
```

## Docker Support

The application can be run with Docker using the provided docker-compose.yml file at the root of the project.

```
docker-compose up -d
```

## Project Structure

- `src/Entity/`: Database entities
- `src/Repository/`: Database queries
- `src/Controller/`: Custom controllers
- `src/ApiResource/`: API resources
- `src/Service/`: Business logic
- `config/`: Application configuration
- `migrations/`: Database migrations