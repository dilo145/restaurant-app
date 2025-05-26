<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\Post;
use ApiPlatform\Metadata\Put;
use ApiPlatform\Metadata\Delete;
use App\Repository\CategoriesRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Serializer\Annotation\Groups;

#[ORM\Entity(repositoryClass: CategoriesRepository::class)]
#[ApiResource(
    operations: [
        new GetCollection(),
        new Get(),
        new Post(security: "is_granted('ROLE_ADMIN') or is_granted('ROLE_HOST')"),
        new Put(security: "is_granted('ROLE_ADMIN') or is_granted('ROLE_HOST')"),
        new Delete(security: "is_granted('ROLE_ADMIN') or is_granted('ROLE_HOST')")
    ],
    normalizationContext: ['groups' => ['category:read']],
    denormalizationContext: ['groups' => ['category:write']]
)]
class Categories
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    #[Groups(['category:read'])]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    #[Groups(['category:read', 'category:write'])]
    private ?string $name = null;

    /**
     * @var Collection<int, MenuItems>
     */
    #[ORM\OneToMany(targetEntity: MenuItems::class, mappedBy: 'category_id')]
    private Collection $menuItems;

    public function __construct()
    {
        $this->menuItems = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): static
    {
        $this->name = $name;

        return $this;
    }

    /**
     * @return Collection<int, MenuItems>
     */
    public function getMenuItems(): Collection
    {
        return $this->menuItems;
    }

    public function addMenuItem(MenuItems $menuItem): static
    {
        if (!$this->menuItems->contains($menuItem)) {
            $this->menuItems->add($menuItem);
            $menuItem->setCategoryId($this);
        }

        return $this;
    }

    public function removeMenuItem(MenuItems $menuItem): static
    {
        if ($this->menuItems->removeElement($menuItem)) {
            // set the owning side to null (unless already changed)
            if ($menuItem->getCategoryId() === $this) {
                $menuItem->setCategoryId(null);
            }
        }

        return $this;
    }
}
