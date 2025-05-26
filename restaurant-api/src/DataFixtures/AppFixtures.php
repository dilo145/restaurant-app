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
        //TODO
    }
}