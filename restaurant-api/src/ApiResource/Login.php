<?php

namespace App\ApiResource;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Post;
use ApiPlatform\OpenApi\Model\Operation;
use ApiPlatform\OpenApi\Model\RequestBody;
use Symfony\Component\Validator\Constraints as Assert;

#[ApiResource(
    shortName: 'Authentication',
    operations: [
        new Post(
            uriTemplate: '/login',
            openapi: new Operation(
                summary: 'Login to the application',
                description: 'Authenticates user with email and password',
                tags: ['Authentication'],
                requestBody: new RequestBody(
                    content: new \ArrayObject([
                        'application/json' => [
                            'schema' => [
                                'type' => 'object',
                                'properties' => [
                                    'email' => ['type' => 'string'],
                                    'password' => ['type' => 'string']
                                ]
                            ]
                        ]
                    ])
                ),
                responses: [
                    '200' => [
                        'description' => 'User authenticated successfully',
                        'content' => [
                            'application/json' => [
                                'schema' => [
                                    'type' => 'object',
                                    'properties' => [
                                        'user' => [
                                            'type' => 'object',
                                            'properties' => [
                                                'id' => ['type' => 'integer'],
                                                'email' => ['type' => 'string'],
                                                'firstname' => ['type' => 'string'],
                                                'lastname' => ['type' => 'string'],
                                                'role' => ['type' => 'string']
                                            ]
                                        ],
                                        'token' => ['type' => 'string']
                                    ]
                                ]
                            ]
                        ]
                    ],
                    '401' => [
                        'description' => 'Invalid credentials',
                    ]
                ]
            ),
            controller: 'App\Controller\SecurityController::login',
            name: 'api_login'
        )
    ]
)]
class Login
{
    #[Assert\NotBlank]
    #[Assert\Email]
    public string $email;

    #[Assert\NotBlank]
    public string $password;
}