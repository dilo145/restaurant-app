<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiResource;
use App\Repository\ReservationsRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: ReservationsRepository::class)]
#[ApiResource]
class Reservations
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(inversedBy: 'reservations')]
    #[ORM\JoinColumn(nullable: false)]
    private ?User $user_id = null;

    /**
     * @var Collection<int, Tables>
     */
    #[ORM\OneToMany(targetEntity: Tables::class, mappedBy: 'reservations')]
    private Collection $table_id;

    #[ORM\ManyToOne(inversedBy: 'reservations')]
    private ?TimeSlots $time_slot_id = null;

    #[ORM\Column(type: Types::DATETIME_MUTABLE)]
    private ?\DateTimeInterface $reservation_date = null;

    #[ORM\Column]
    private ?int $guest_count = null;

    #[ORM\Column]
    private ?\DateTimeImmutable $created_at = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $updated_at = null;

    public function __construct()
    {
        $this->table_id = new ArrayCollection();
    }

    public function getUserId(): ?user
    {
        return $this->user_id;
    }

    public function setUserId(?user $user_id): static
    {
        $this->user_id = $user_id;

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

    public function getTimeSlotId(): ?TimeSlots
    {
        return $this->time_slot_id;
    }

    public function setTimeSlotId(?TimeSlots $time_slot_id): static
    {
        $this->time_slot_id = $time_slot_id;

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
