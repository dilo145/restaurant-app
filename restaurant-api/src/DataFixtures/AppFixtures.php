<?php

namespace App\DataFixtures;

use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use App\Entity\Client;
use App\Entity\Site;
use App\Entity\Building;
use App\Entity\BuildingLevel;
use App\Entity\Section;
use App\Entity\SectionLevel;
use App\Entity\Intervention;
use App\Entity\RegulatoryReportType;
use App\Entity\Observation;
use App\Entity\User;
use App\Entity\Subscription;
use App\Entity\EquipmentDomain;
use App\Entity\EquipmentFamily;
use App\Entity\EquipmentType;
use App\Entity\Brand;
use App\Entity\ProductDocumentType;
use App\Entity\ProductDocument;
use App\Entity\Product;
use App\Entity\RegulatoryReport;
use App\Entity\File;
use App\Entity\Lot;
use App\Entity\ProductSection;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        // --- USERS ---
        $admin = new User();
        $admin->setFirstname('Admin')
            ->setLastname('User')
            ->setEmail('admin@restaurant.com')
            ->setPassword(password_hash('adminpass', PASSWORD_BCRYPT))
            ->setRole(\App\Entity\UserRole::ADMIN)
            ->setPhone('0600000000')
            ->setAddress('1 Admin Street');
        $manager->persist($admin);

        $host = new User();
        $host->setFirstname('Host')
            ->setLastname('User')
            ->setEmail('host@restaurant.com')
            ->setPassword(password_hash('hostpass', PASSWORD_BCRYPT))
            ->setRole(\App\Entity\UserRole::HOST)
            ->setPhone('0611111111')
            ->setAddress('2 Host Avenue');
        $manager->persist($host);

        $user = new User();
        $user->setFirstname('John')
            ->setLastname('Doe')
            ->setEmail('user@restaurant.com')
            ->setPassword(password_hash('userpass', PASSWORD_BCRYPT))
            ->setRole(\App\Entity\UserRole::USER)
            ->setPhone('0622222222')
            ->setAddress('3 User Road');
        $manager->persist($user);

        // --- CATEGORIES ---
        $categories = [];
        foreach (["Entrée", "Plat", "Dessert", "Boisson"] as $catName) {
            $cat = new \App\Entity\Categories();
            $cat->setName($catName);
            $manager->persist($cat);
            $categories[$catName] = $cat;
        }

        // --- MENU ITEMS ---
        $menuItemsData = [
            ['Salade César', 'Salade, poulet, parmesan, croûtons', 8.5, 'Entrée'],
            ['Steak Frites', 'Steak de boeuf, frites maison', 15.0, 'Plat'],
            ['Tiramisu', 'Dessert italien au café', 6.0, 'Dessert'],
            ['Coca-Cola', 'Boisson gazeuse', 3.0, 'Boisson'],
        ];
        foreach ($menuItemsData as [$name, $desc, $price, $cat]) {
            $item = new \App\Entity\MenuItems();
            $item->setName($name)
                ->setDescription($desc)
                ->setPrice($price)
                ->setCreatedAt(new \DateTimeImmutable())
                ->setCategory($categories[$cat]);
            $manager->persist($item);
        }

        // --- TABLES ---
        $tables = [];
        foreach ([2, 4, 6] as $i => $capacity) {
            $table = new \App\Entity\Tables();
            $table->setName('Table ' . ($i+1))
                ->setCapacity($capacity);
            $manager->persist($table);
            $tables[] = $table;
        }

        // --- TIME SLOTS ---
        $timeSlots = [];
        $slotTimes = [
            ['12:00', '14:00'],
            ['19:00', '21:00'],
        ];
        foreach ($slotTimes as [$start, $end]) {
            $slot = new \App\Entity\TimeSlots();
            $slot->setStartTime(new \DateTime($start))
                ->setEndTime(new \DateTime($end))
                ->setMaxCovers(20);
            $manager->persist($slot);
            $timeSlots[] = $slot;
        }

        // --- RESERVATIONS ---
        $reservation = new \App\Entity\Reservations();
        $reservation->setUser($user)
            // ->setReservationDate(new \DateTime('tomorrow 12:30'))
            ->setGuestCount(2)
            // ->setCreatedAt(new \DateTimeImmutable())
            ->setTimeSlot($timeSlots[0]);
        foreach ([$tables[0], $tables[1]] as $table) {
            $reservation->addTableId($table);
        }
        $manager->persist($reservation);

        $manager->flush();
    }
}
