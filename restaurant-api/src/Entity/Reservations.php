<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Link;
use App\Repository\ReservationsRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Serializer\Annotation\Groups;

#[ORM\Entity(repositoryClass: ReservationsRepository::class)]
#[ApiResource(
    normalizationContext: ['groups' => ['reservation:read']],
    denormalizationContext: ['groups' => ['reservation:write']]
)]
#[ApiResource(
    uriTemplate: '/users/{user_id}/reservations',
    operations: [
        new GetCollection(
            uriVariables: [
                'user_id' => new Link(
                    fromProperty: 'reservations',
                    fromClass: User::class
                )
            ],
            description: 'Retrieves the collection of Reservations for a specific User',
            normalizationContext: ['groups' => ['reservation:read']]
        )
    ]
)]
class Reservations
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    #[Groups(['reservation:read', 'user:read'])]
    private ?int $id = null;

    #[ORM\ManyToOne(inversedBy: 'reservations')]
    #[ORM\JoinColumn(nullable: false)]
    #[Groups(['reservation:read', 'reservation:write'])]
    private ?User $user = null;

    /**
     * @var Collection<int, Tables>
     */
    #[ORM\OneToMany(targetEntity: Tables::class, mappedBy: 'reservations')]
    #[Groups(['reservation:read', 'reservation:write', 'user:read'])]
    private Collection $table_id;

    #[ORM\ManyToOne(inversedBy: 'reservations')]
    #[Groups(['reservation:read', 'reservation:write', 'user:read'])]
    private ?TimeSlots $time_slot = null;

    #[ORM\Column(type: Types::DATETIME_MUTABLE)]
    #[Groups(['reservation:read', 'reservation:write', 'user:read'])]
    private ?\DateTimeInterface $reservation_date = null;

    #[ORM\Column]
    #[Groups(['reservation:read', 'reservation:write', 'user:read'])]
    private ?int $guest_count = null;

    #[ORM\Column]
    #[Groups(['reservation:read', 'user:read'])]
    private ?\DateTimeImmutable $created_at = null;

    #[ORM\Column(nullable: true)]
    #[Groups(['reservation:read', 'user:read'])]
    private ?\DateTimeImmutable $updated_at = null;

    public function __construct()
    {
        $this->table_id = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getUser(): ?User
    {
        return $this->user;
    }

    public function setUser(?User $user): static
    {
        $this->user = $user;

        return $this;
    }

    /**
     * @return Collection<int, Tables>
     */
    public function getTableId(): Collection
    {
        return $this->table_id;
    }

    public function addTableId(Tables $tableId): static
    {
        if (!$this->table_id->contains($tableId)) {
            $this->table_id->add($tableId);
            $tableId->setReservations($this);
        }

        return $this;
    }

    public function removeTableId(Tables $tableId): static
    {
        if ($this->table_id->removeElement($tableId)) {
            // set the owning side to null (unless already changed)
            if ($tableId->getReservations() === $this) {
                $tableId->setReservations(null);
            }
        }

        return $this;
    }

    public function getTimeSlot(): ?TimeSlots
    {
        return $this->time_slot;
    }

    public function setTimeSlot(?TimeSlots $time_slot): static
    {
        $this->time_slot = $time_slot;

        return $this;
    }

    public function getReservationDate(): ?\DateTimeInterface
    {
        return $this->reservation_date;
    }

    public function setReservationDate(\DateTimeInterface $reservation_date): static
    {
        $this->reservation_date = $reservation_date;

        return $this;
    }

    public function getGuestCount(): ?int
    {
        return $this->guest_count;
    }

    public function setGuestCount(int $guest_count): static
    {
        $this->guest_count = $guest_count;

        return $this;
    }

    public function getCreatedAt(): ?\DateTimeImmutable
    {
        return $this->created_at;
    }

    public function setCreatedAt(\DateTimeImmutable $created_at): static
    {
        $this->created_at = $created_at;

        return $this;
    }

    public function getUpdatedAt(): ?\DateTimeImmutable
    {
        return $this->updated_at;
    }

    public function setUpdatedAt(?\DateTimeImmutable $updated_at): static
    {
        $this->updated_at = $updated_at;

        return $this;
    }
}
