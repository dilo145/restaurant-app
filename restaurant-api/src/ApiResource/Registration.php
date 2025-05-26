<?php

namespace App\ApiResource;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Post;
use ApiPlatform\OpenApi\Model\Operation;
use ApiPlatform\OpenApi\Model\RequestBody;
use Symfony\Component\Validator\Constraints as Assert;

#[ApiResource(
    shortName: 'Registration',
    operations: [
        new Post(
            uriTemplate: '/register',
            controller: 'App\Controller\SecurityController::register',
            openapi: new Operation(
//                tags: ['Authentication'],
                responses: [
                    '201' => [
                        'description' => 'User registered successfully',
                        'content' => [
                            'application/json' => [
                                'schema' => [
                                    'type' => 'object',
                                    'properties' => [
                                        'message' => ['type' => 'string'],
                                        'user' => [
                                            'type' => 'object',
                                            'properties' => [
                                                'id' => ['type' => 'integer'],
                                                'email' => ['type' => 'string']
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],
                    '400' => [
                        'description' => 'Bad request - missing fields or user already exists',
                    ]
                ],
                summary: 'Register a new user',
                description: 'Creates a new user account',
                requestBody: new RequestBody(
                    content: new \ArrayObject([
                        'application/json' => [
                            'schema' => [
                                'type' => 'object',
                                'properties' => [
                                    'email' => ['type' => 'string'],
                                    'password' => ['type' => 'string'],
                                    'firstname' => ['type' => 'string'],
                                    'lastname' => ['type' => 'string'],
                                    'phone' => ['type' => 'string', 'nullable' => true],
                                    'address' => ['type' => 'string', 'nullable' => true]
                                ],
                                'required' => ['email', 'password', 'firstname', 'lastname']
                            ]
                        ]
                    ])
                )
            ),
            name: 'api_register'
        )
    ]
)]
class Registration
{
    #[Assert\NotBlank]
    #[Assert\Email]
    public string $email;

    #[Assert\NotBlank]
    public string $password;

    #[Assert\NotBlank]
    public string $firstname;

    #[Assert\NotBlank]
    public string $lastname;

    public ?string $phone = null;

    public ?string $address = null;
}