<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20250428215424 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql(<<<'SQL'
            CREATE TABLE brand (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, serial_number VARCHAR(255) NOT NULL, UNIQUE INDEX UNIQ_1C52F9585E237E06 (name), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE building (id INT AUTO_INCREMENT NOT NULL, site_id INT NOT NULL, label VARCHAR(255) NOT NULL, erp_type VARCHAR(50) DEFAULT NULL, erp_category VARCHAR(50) DEFAULT NULL, igh_class VARCHAR(50) DEFAULT NULL, hab_family VARCHAR(50) DEFAULT NULL, INDEX IDX_E16F61D4F6BD1646 (site_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE building_level (id INT AUTO_INCREMENT NOT NULL, building_id INT NOT NULL, label VARCHAR(255) NOT NULL, INDEX IDX_F64A7D894D2A7E12 (building_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE client (id INT AUTO_INCREMENT NOT NULL, firstname VARCHAR(255) NOT NULL, lastname VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL, phone VARCHAR(30) DEFAULT NULL, address VARCHAR(255) DEFAULT NULL, reference VARCHAR(100) DEFAULT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE equipment_domain (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, UNIQUE INDEX UNIQ_27614B5E237E06 (name), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE equipment_family (id INT AUTO_INCREMENT NOT NULL, domain_id INT NOT NULL, name VARCHAR(255) NOT NULL, INDEX IDX_2685E1B115F0EE5 (domain_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE equipment_type (id INT AUTO_INCREMENT NOT NULL, family_id INT NOT NULL, title VARCHAR(255) NOT NULL, subtitle VARCHAR(255) DEFAULT NULL, inventory_required TINYINT(1) NOT NULL, additional_fields JSON DEFAULT NULL, INDEX IDX_B65A862FC35E566A (family_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE file (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, path VARCHAR(255) NOT NULL, type VARCHAR(50) NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE intervention (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, company VARCHAR(255) NOT NULL, operator VARCHAR(255) NOT NULL, status VARCHAR(50) NOT NULL, type VARCHAR(50) NOT NULL, operator_signature VARCHAR(255) DEFAULT NULL, intervention_date DATETIME NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE intervention_section (intervention_id INT NOT NULL, section_id INT NOT NULL, INDEX IDX_669D0E8A8EAE3863 (intervention_id), INDEX IDX_669D0E8AD823E37A (section_id), PRIMARY KEY(intervention_id, section_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE lot (id INT AUTO_INCREMENT NOT NULL, building_id INT NOT NULL, name VARCHAR(255) NOT NULL, INDEX IDX_B81291B4D2A7E12 (building_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE observation (id INT AUTO_INCREMENT NOT NULL, report_id INT NOT NULL, file_id INT DEFAULT NULL, identifier VARCHAR(50) NOT NULL, label VARCHAR(255) NOT NULL, location VARCHAR(255) DEFAULT NULL, priority VARCHAR(50) DEFAULT NULL, status VARCHAR(50) NOT NULL, already_reported TINYINT(1) NOT NULL, report_date DATE DEFAULT NULL, INDEX IDX_C576DBE04BD2A4C0 (report_id), INDEX IDX_C576DBE093CB796C (file_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE observation_section (observation_id INT NOT NULL, section_id INT NOT NULL, INDEX IDX_8FA1603B1409DD88 (observation_id), INDEX IDX_8FA1603BD823E37A (section_id), PRIMARY KEY(observation_id, section_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE product (id INT AUTO_INCREMENT NOT NULL, brand_id INT NOT NULL, equipment_type_id INT NOT NULL, name VARCHAR(255) NOT NULL, serial_number VARCHAR(255) DEFAULT NULL, INDEX IDX_D34A04AD44F5D008 (brand_id), INDEX IDX_D34A04ADB337437C (equipment_type_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE product_association (product_id INT NOT NULL, associated_product_id INT NOT NULL, INDEX IDX_51AABFD34584665A (product_id), INDEX IDX_51AABFD3AE33471B (associated_product_id), PRIMARY KEY(product_id, associated_product_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE product_document (id INT AUTO_INCREMENT NOT NULL, file_id INT NOT NULL, type_id INT NOT NULL, product_id INT NOT NULL, INDEX IDX_13D9E0E193CB796C (file_id), INDEX IDX_13D9E0E1C54C8C93 (type_id), INDEX IDX_13D9E0E14584665A (product_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE product_document_type (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, UNIQUE INDEX UNIQ_F187C7485E237E06 (name), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE product_section (id INT AUTO_INCREMENT NOT NULL, product_id INT NOT NULL, section_id INT NOT NULL, location VARCHAR(255) NOT NULL, commissioning_date DATE NOT NULL, INDEX IDX_FCAA615F4584665A (product_id), INDEX IDX_FCAA615FD823E37A (section_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE regulatory_report (id INT AUTO_INCREMENT NOT NULL, type_id INT NOT NULL, intervention_id INT DEFAULT NULL, issue_date DATE NOT NULL, status VARCHAR(50) NOT NULL, INDEX IDX_91F7B96C54C8C93 (type_id), INDEX IDX_91F7B968EAE3863 (intervention_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE report_section (regulatory_report_id INT NOT NULL, section_id INT NOT NULL, INDEX IDX_4DEA07EFDE1CACB3 (regulatory_report_id), INDEX IDX_4DEA07EFD823E37A (section_id), PRIMARY KEY(regulatory_report_id, section_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE regulatory_report_type (id INT AUTO_INCREMENT NOT NULL, label VARCHAR(255) NOT NULL, subtitle VARCHAR(255) DEFAULT NULL, periodicity INT NOT NULL, building_typologies JSON NOT NULL, certified_organization_required TINYINT(1) NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE section (id INT AUTO_INCREMENT NOT NULL, building_id INT NOT NULL, name VARCHAR(255) NOT NULL, type VARCHAR(20) NOT NULL, public_capacity INT DEFAULT NULL, staff_capacity INT DEFAULT NULL, operation_area DOUBLE PRECISION DEFAULT NULL, gla_area DOUBLE PRECISION DEFAULT NULL, public_access_area DOUBLE PRECISION DEFAULT NULL, icpe TINYINT(1) NOT NULL, activity_type VARCHAR(50) DEFAULT NULL, INDEX IDX_2D737AEF4D2A7E12 (building_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE section_lot (section_id INT NOT NULL, lot_id INT NOT NULL, INDEX IDX_D05DFA49D823E37A (section_id), INDEX IDX_D05DFA49A8CBA5F7 (lot_id), PRIMARY KEY(section_id, lot_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE section_level (id INT AUTO_INCREMENT NOT NULL, section_id INT NOT NULL, building_level_id INT NOT NULL, label VARCHAR(255) NOT NULL, INDEX IDX_DBDAB77D823E37A (section_id), INDEX IDX_DBDAB77843D4AFC (building_level_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE site (id INT AUTO_INCREMENT NOT NULL, client_id INT NOT NULL, name VARCHAR(255) NOT NULL, address VARCHAR(255) NOT NULL, reference VARCHAR(255) NOT NULL, typology VARCHAR(20) NOT NULL, INDEX IDX_694309E419EB6921 (client_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE subscription (id INT AUTO_INCREMENT NOT NULL, client_id INT NOT NULL, user_id INT NOT NULL, type VARCHAR(50) NOT NULL, start_date DATE NOT NULL, end_date DATE NOT NULL, INDEX IDX_A3C664D319EB6921 (client_id), INDEX IDX_A3C664D3A76ED395 (user_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE user (id INT AUTO_INCREMENT NOT NULL, client_id INT NOT NULL, firstname VARCHAR(255) NOT NULL, lastname VARCHAR(255) NOT NULL, email VARCHAR(180) NOT NULL, password VARCHAR(255) NOT NULL, role VARCHAR(50) NOT NULL, permissions JSON DEFAULT NULL, UNIQUE INDEX UNIQ_8D93D649E7927C74 (email), INDEX IDX_8D93D64919EB6921 (client_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE building ADD CONSTRAINT FK_E16F61D4F6BD1646 FOREIGN KEY (site_id) REFERENCES site (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE building_level ADD CONSTRAINT FK_F64A7D894D2A7E12 FOREIGN KEY (building_id) REFERENCES building (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE equipment_family ADD CONSTRAINT FK_2685E1B115F0EE5 FOREIGN KEY (domain_id) REFERENCES equipment_domain (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE equipment_type ADD CONSTRAINT FK_B65A862FC35E566A FOREIGN KEY (family_id) REFERENCES equipment_family (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE intervention_section ADD CONSTRAINT FK_669D0E8A8EAE3863 FOREIGN KEY (intervention_id) REFERENCES intervention (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE intervention_section ADD CONSTRAINT FK_669D0E8AD823E37A FOREIGN KEY (section_id) REFERENCES section (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE lot ADD CONSTRAINT FK_B81291B4D2A7E12 FOREIGN KEY (building_id) REFERENCES building (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE observation ADD CONSTRAINT FK_C576DBE04BD2A4C0 FOREIGN KEY (report_id) REFERENCES regulatory_report (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE observation ADD CONSTRAINT FK_C576DBE093CB796C FOREIGN KEY (file_id) REFERENCES file (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE observation_section ADD CONSTRAINT FK_8FA1603B1409DD88 FOREIGN KEY (observation_id) REFERENCES observation (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE observation_section ADD CONSTRAINT FK_8FA1603BD823E37A FOREIGN KEY (section_id) REFERENCES section (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product ADD CONSTRAINT FK_D34A04AD44F5D008 FOREIGN KEY (brand_id) REFERENCES brand (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product ADD CONSTRAINT FK_D34A04ADB337437C FOREIGN KEY (equipment_type_id) REFERENCES equipment_type (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_association ADD CONSTRAINT FK_51AABFD34584665A FOREIGN KEY (product_id) REFERENCES product (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_association ADD CONSTRAINT FK_51AABFD3AE33471B FOREIGN KEY (associated_product_id) REFERENCES product (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_document ADD CONSTRAINT FK_13D9E0E193CB796C FOREIGN KEY (file_id) REFERENCES file (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_document ADD CONSTRAINT FK_13D9E0E1C54C8C93 FOREIGN KEY (type_id) REFERENCES product_document_type (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_document ADD CONSTRAINT FK_13D9E0E14584665A FOREIGN KEY (product_id) REFERENCES product (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_section ADD CONSTRAINT FK_FCAA615F4584665A FOREIGN KEY (product_id) REFERENCES product (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_section ADD CONSTRAINT FK_FCAA615FD823E37A FOREIGN KEY (section_id) REFERENCES section (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE regulatory_report ADD CONSTRAINT FK_91F7B96C54C8C93 FOREIGN KEY (type_id) REFERENCES regulatory_report_type (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE regulatory_report ADD CONSTRAINT FK_91F7B968EAE3863 FOREIGN KEY (intervention_id) REFERENCES intervention (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE report_section ADD CONSTRAINT FK_4DEA07EFDE1CACB3 FOREIGN KEY (regulatory_report_id) REFERENCES regulatory_report (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE report_section ADD CONSTRAINT FK_4DEA07EFD823E37A FOREIGN KEY (section_id) REFERENCES section (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section ADD CONSTRAINT FK_2D737AEF4D2A7E12 FOREIGN KEY (building_id) REFERENCES building (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section_lot ADD CONSTRAINT FK_D05DFA49D823E37A FOREIGN KEY (section_id) REFERENCES section (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section_lot ADD CONSTRAINT FK_D05DFA49A8CBA5F7 FOREIGN KEY (lot_id) REFERENCES lot (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section_level ADD CONSTRAINT FK_DBDAB77D823E37A FOREIGN KEY (section_id) REFERENCES section (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section_level ADD CONSTRAINT FK_DBDAB77843D4AFC FOREIGN KEY (building_level_id) REFERENCES building_level (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE site ADD CONSTRAINT FK_694309E419EB6921 FOREIGN KEY (client_id) REFERENCES client (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE subscription ADD CONSTRAINT FK_A3C664D319EB6921 FOREIGN KEY (client_id) REFERENCES client (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE subscription ADD CONSTRAINT FK_A3C664D3A76ED395 FOREIGN KEY (user_id) REFERENCES user (id)
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE user ADD CONSTRAINT FK_8D93D64919EB6921 FOREIGN KEY (client_id) REFERENCES client (id)
        SQL);
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql(<<<'SQL'
            ALTER TABLE building DROP FOREIGN KEY FK_E16F61D4F6BD1646
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE building_level DROP FOREIGN KEY FK_F64A7D894D2A7E12
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE equipment_family DROP FOREIGN KEY FK_2685E1B115F0EE5
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE equipment_type DROP FOREIGN KEY FK_B65A862FC35E566A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE intervention_section DROP FOREIGN KEY FK_669D0E8A8EAE3863
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE intervention_section DROP FOREIGN KEY FK_669D0E8AD823E37A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE lot DROP FOREIGN KEY FK_B81291B4D2A7E12
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE observation DROP FOREIGN KEY FK_C576DBE04BD2A4C0
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE observation DROP FOREIGN KEY FK_C576DBE093CB796C
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE observation_section DROP FOREIGN KEY FK_8FA1603B1409DD88
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE observation_section DROP FOREIGN KEY FK_8FA1603BD823E37A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product DROP FOREIGN KEY FK_D34A04AD44F5D008
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product DROP FOREIGN KEY FK_D34A04ADB337437C
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_association DROP FOREIGN KEY FK_51AABFD34584665A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_association DROP FOREIGN KEY FK_51AABFD3AE33471B
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_document DROP FOREIGN KEY FK_13D9E0E193CB796C
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_document DROP FOREIGN KEY FK_13D9E0E1C54C8C93
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_document DROP FOREIGN KEY FK_13D9E0E14584665A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_section DROP FOREIGN KEY FK_FCAA615F4584665A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE product_section DROP FOREIGN KEY FK_FCAA615FD823E37A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE regulatory_report DROP FOREIGN KEY FK_91F7B96C54C8C93
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE regulatory_report DROP FOREIGN KEY FK_91F7B968EAE3863
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE report_section DROP FOREIGN KEY FK_4DEA07EFDE1CACB3
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE report_section DROP FOREIGN KEY FK_4DEA07EFD823E37A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section DROP FOREIGN KEY FK_2D737AEF4D2A7E12
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section_lot DROP FOREIGN KEY FK_D05DFA49D823E37A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section_lot DROP FOREIGN KEY FK_D05DFA49A8CBA5F7
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section_level DROP FOREIGN KEY FK_DBDAB77D823E37A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE section_level DROP FOREIGN KEY FK_DBDAB77843D4AFC
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE site DROP FOREIGN KEY FK_694309E419EB6921
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE subscription DROP FOREIGN KEY FK_A3C664D319EB6921
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE subscription DROP FOREIGN KEY FK_A3C664D3A76ED395
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE user DROP FOREIGN KEY FK_8D93D64919EB6921
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE brand
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE building
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE building_level
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE client
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE equipment_domain
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE equipment_family
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE equipment_type
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE file
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE intervention
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE intervention_section
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE lot
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE observation
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE observation_section
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE product
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE product_association
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE product_document
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE product_document_type
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE product_section
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE regulatory_report
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE report_section
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE regulatory_report_type
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE section
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE section_lot
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE section_level
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE site
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE subscription
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE user
        SQL);
    }
}
