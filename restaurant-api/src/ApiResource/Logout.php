<?php

namespace App\ApiResource;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Post;
use ApiPlatform\OpenApi\Model\Operation;

#[ApiResource(
    shortName: 'Logout',
    operations: [
        new Post(
            uriTemplate: '/logout',
            openapi: new Operation(
                summary: 'Logout from the application',
                description: 'Invalidates the current user session',
                tags: ['Authentication'],
                responses: [
                    '200' => [
                        'description' => 'Successfully logged out',
                        'content' => [
                            'application/json' => [
                                'schema' => [
                                    'type' => 'object',
                                    'properties' => [
                                        'message' => ['type' => 'string']
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ),
            controller: 'App\Controller\SecurityController::logout',
            name: 'api_logout'
        )
    ]
)]
class Logout
{
}