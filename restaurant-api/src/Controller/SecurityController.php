<?php

namespace App\Controller;

use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Annotation\Route;
use Lexik\Bundle\JWTAuthenticationBundle\Services\JWTTokenManagerInterface;

class SecurityController extends AbstractController
{
    #[Route('/api/login', name: 'api_login', methods: ['POST'])]
    public function login(
        Request $request,
        UserPasswordHasherInterface $passwordHasher,
        EntityManagerInterface $entityManager,
        JWTTokenManagerInterface $JWTManager
    ): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        if (!isset($data['email']) || !isset($data['password'])) {
            return $this->json([
                'message' => 'Missing email or password',
            ], Response::HTTP_BAD_REQUEST);
        }

        $user = $entityManager->getRepository(User::class)->findOneBy(['email' => $data['email']]);

        if (!$user) {
            return $this->json([
                'message' => 'Invalid credentials',
            ], Response::HTTP_UNAUTHORIZED);
        }

        if (!$passwordHasher->isPasswordValid($user, $data['password'])) {
            return $this->json([
                'message' => 'Invalid credentials',
            ], Response::HTTP_UNAUTHORIZED);
        }

        // Create custom payload for JWT
        $payload = [
            'id' => $user->getId(),
            'email' => $user->getEmail(),
            'firstname' => $user->getFirstname(),
            'lastname' => $user->getLastname(),
            'role' => $user->getRole()->value,
        ];

        // Add optional fields if they exist
        if ($user->getPhone() !== null) {
            $payload['phone'] = $user->getPhone();
        }

        if ($user->getAddress() !== null) {
            $payload['address'] = $user->getAddress();
        }

        $token = $JWTManager->createFromPayload($user, $payload);

        return $this->json([
            'token' => $token
        ]);
    }

    #[Route('/api/register', name: 'api_register', methods: ['POST'])]
    public function register(
        Request $request,
        UserPasswordHasherInterface $passwordHasher,
        EntityManagerInterface $entityManager
    ): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        if (!isset($data['email']) || !isset($data['password']) ||
            !isset($data['firstname']) || !isset($data['lastname'])) {
            return $this->json([
                'message' => 'Missing required fields',
            ], Response::HTTP_BAD_REQUEST);
        }

        $existingUser = $entityManager->getRepository(User::class)->findOneBy(['email' => $data['email']]);
        if ($existingUser) {
            return $this->json([
                'message' => 'User with this email already exists',
            ], Response::HTTP_BAD_REQUEST);
        }

        // Uncomment the following lines to enforce password complexity
        // if (
        //     strlen($data['password']) < 12 ||
        //     !preg_match('/[A-Z]/', $data['password']) ||
        //     !preg_match('/[a-z]/', $data['password']) ||
        //     !preg_match('/[0-9]/', $data['password'])
        // ) {
        //     return $this->json([
        //         'message' => 'Password must be at least 12 characters long and contain at least one uppercase letter, one lowercase letter, and one number.',
        //     ], Response::HTTP_BAD_REQUEST);
        // }

        if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            return $this->json([
                'message' => 'Invalid email format',
            ], Response::HTTP_BAD_REQUEST);
        }

        $user = new User();
        $user->setEmail($data['email']);
        $user->setFirstname($data['firstname']);
        $user->setLastname($data['lastname']);

        $hashedPassword = $passwordHasher->hashPassword(
            $user,
            $data['password']
        );
        $user->setPassword($hashedPassword);

        if (isset($data['phone'])) {
            $user->setPhone($data['phone']);
        }

        if (isset($data['address'])) {
            $user->setAddress($data['address']);
        }

        $entityManager->persist($user);
        $entityManager->flush();

        return $this->json([
            'message' => 'User registered successfully',
            'user' => [
                'id' => $user->getId(),
                'email' => $user->getEmail(),
            ],
        ], Response::HTTP_CREATED);
    }

    #[Route('/api/profil', name: 'api_profil', methods: ['GET'])]
    public function getCurrentUser(): JsonResponse
    {
        $user = $this->getUser();

        if (!$user instanceof User) {
            return $this->json([
                'message' => 'Not authenticated',
            ], Response::HTTP_UNAUTHORIZED);
        }

        return $this->json([
            'user' => [
                'id' => $user->getId(),
                'email' => $user->getEmail(),
                'firstname' => $user->getFirstname(),
                'lastname' => $user->getLastname(),
                'role' => $user->getRole()->value,
                'phone' => $user->getPhone(),
                'address' => $user->getAddress(),
            ],
        ]);
    }

    #[Route('/api/logout', name: 'api_logout', methods: ['POST'])]
    public function logout(): JsonResponse
    {
        // In a real implementation with tokens, you would invalidate the token here
        // For a session-based auth, Symfony's security system handles logout automatically

        return $this->json([
            'message' => 'Successfully logged out',
        ]);
    }
}