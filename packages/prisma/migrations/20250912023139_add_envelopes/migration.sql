/*
  Warnings:

  - You are about to drop the column `documentId` on the `DocumentAuditLog` table. All the data in the column will be lost.
  - You are about to drop the column `documentId` on the `DocumentMeta` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `DocumentMeta` table. All the data in the column will be lost.
  - You are about to drop the column `templateId` on the `DocumentMeta` table. All the data in the column will be lost.
  - You are about to drop the column `documentId` on the `DocumentShareLink` table. All the data in the column will be lost.
  - You are about to drop the column `documentId` on the `Field` table. All the data in the column will be lost.
  - You are about to drop the column `templateId` on the `Field` table. All the data in the column will be lost.
  - You are about to drop the column `documentId` on the `Recipient` table. All the data in the column will be lost.
  - You are about to drop the column `templateId` on the `Recipient` table. All the data in the column will be lost.
  - You are about to drop the column `templateId` on the `TemplateDirectLink` table. All the data in the column will be lost.
  - You are about to drop the `Document` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Template` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[envelopeId,email]` on the table `DocumentShareLink` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[envelopeId,email]` on the table `Recipient` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[envelopeId]` on the table `TemplateDirectLink` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `envelopeId` to the `DocumentAuditLog` table without a default value. This is not possible if the table is not empty.
  - Added the required column `envelopeId` to the `DocumentShareLink` table without a default value. This is not possible if the table is not empty.
  - Added the required column `envelopeId` to the `Field` table without a default value. This is not possible if the table is not empty.
  - Added the required column `envelopeItemId` to the `Field` table without a default value. This is not possible if the table is not empty.
  - Added the required column `envelopeId` to the `Recipient` table without a default value. This is not possible if the table is not empty.
  - Added the required column `envelopeId` to the `TemplateDirectLink` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "EnvelopeType" AS ENUM ('DOCUMENT', 'TEMPLATE');

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_documentDataId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_folderId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_teamId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_templateId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_userId_fkey";

-- DropForeignKey
ALTER TABLE "DocumentAuditLog" DROP CONSTRAINT "DocumentAuditLog_documentId_fkey";

-- DropForeignKey
ALTER TABLE "DocumentMeta" DROP CONSTRAINT "DocumentMeta_documentId_fkey";

-- DropForeignKey
ALTER TABLE "DocumentMeta" DROP CONSTRAINT "DocumentMeta_templateId_fkey";

-- DropForeignKey
ALTER TABLE "DocumentShareLink" DROP CONSTRAINT "DocumentShareLink_documentId_fkey";

-- DropForeignKey
ALTER TABLE "Field" DROP CONSTRAINT "Field_documentId_fkey";

-- DropForeignKey
ALTER TABLE "Field" DROP CONSTRAINT "Field_templateId_fkey";

-- DropForeignKey
ALTER TABLE "Recipient" DROP CONSTRAINT "Recipient_documentId_fkey";

-- DropForeignKey
ALTER TABLE "Recipient" DROP CONSTRAINT "Recipient_templateId_fkey";

-- DropForeignKey
ALTER TABLE "Template" DROP CONSTRAINT "Template_folderId_fkey";

-- DropForeignKey
ALTER TABLE "Template" DROP CONSTRAINT "Template_teamId_fkey";

-- DropForeignKey
ALTER TABLE "Template" DROP CONSTRAINT "Template_templateDocumentDataId_fkey";

-- DropForeignKey
ALTER TABLE "Template" DROP CONSTRAINT "Template_userId_fkey";

-- DropForeignKey
ALTER TABLE "TemplateDirectLink" DROP CONSTRAINT "TemplateDirectLink_templateId_fkey";

-- DropIndex
DROP INDEX "DocumentMeta_documentId_key";

-- DropIndex
DROP INDEX "DocumentMeta_templateId_key";

-- DropIndex
DROP INDEX "DocumentShareLink_documentId_email_key";

-- DropIndex
DROP INDEX "Field_documentId_idx";

-- DropIndex
DROP INDEX "Field_templateId_idx";

-- DropIndex
DROP INDEX "Recipient_documentId_email_key";

-- DropIndex
DROP INDEX "Recipient_documentId_idx";

-- DropIndex
DROP INDEX "Recipient_templateId_email_key";

-- DropIndex
DROP INDEX "Recipient_templateId_idx";

-- DropIndex
DROP INDEX "TemplateDirectLink_templateId_key";

-- AlterTable
ALTER TABLE "DocumentAuditLog" DROP COLUMN "documentId",
ADD COLUMN     "envelopeId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "DocumentMeta" DROP COLUMN "documentId",
DROP COLUMN "password",
DROP COLUMN "templateId";

-- AlterTable
ALTER TABLE "DocumentShareLink" DROP COLUMN "documentId",
ADD COLUMN     "envelopeId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Field" DROP COLUMN "documentId",
DROP COLUMN "templateId",
ADD COLUMN     "envelopeId" TEXT NOT NULL,
ADD COLUMN     "envelopeItemId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Recipient" DROP COLUMN "documentId",
DROP COLUMN "templateId",
ADD COLUMN     "envelopeId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "TemplateDirectLink" DROP COLUMN "templateId",
ADD COLUMN     "envelopeId" TEXT NOT NULL;

-- DropTable
DROP TABLE "Document";

-- DropTable
DROP TABLE "Template";

-- CreateTable
CREATE TABLE "Envelope" (
    "id" TEXT NOT NULL,
    "secondaryId" TEXT NOT NULL,
    "externalId" TEXT,
    "type" "EnvelopeType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),
    "deletedAt" TIMESTAMP(3),
    "title" TEXT NOT NULL,
    "status" "DocumentStatus" NOT NULL DEFAULT 'DRAFT',
    "source" "DocumentSource" NOT NULL,
    "qrToken" TEXT,
    "useLegacyFieldInsertion" BOOLEAN NOT NULL DEFAULT false,
    "authOptions" JSONB,
    "formValues" JSONB,
    "visibility" "DocumentVisibility" NOT NULL DEFAULT 'EVERYONE',
    "templateType" "TemplateType" NOT NULL DEFAULT 'PRIVATE',
    "publicTitle" TEXT NOT NULL DEFAULT '',
    "publicDescription" TEXT NOT NULL DEFAULT '',
    "templateId" INTEGER,
    "userId" INTEGER NOT NULL,
    "teamId" INTEGER NOT NULL,
    "folderId" TEXT,
    "documentMetaId" TEXT NOT NULL,

    CONSTRAINT "Envelope_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EnvelopeItem" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "documentDataId" TEXT NOT NULL,
    "envelopeId" TEXT NOT NULL,

    CONSTRAINT "EnvelopeItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Counter" (
    "id" TEXT NOT NULL,
    "value" INTEGER NOT NULL,

    CONSTRAINT "Counter_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Envelope_secondaryId_key" ON "Envelope"("secondaryId");

-- CreateIndex
CREATE UNIQUE INDEX "Envelope_documentMetaId_key" ON "Envelope"("documentMetaId");

-- CreateIndex
CREATE UNIQUE INDEX "EnvelopeItem_documentDataId_key" ON "EnvelopeItem"("documentDataId");

-- CreateIndex
CREATE UNIQUE INDEX "DocumentShareLink_envelopeId_email_key" ON "DocumentShareLink"("envelopeId", "email");

-- CreateIndex
CREATE INDEX "Field_envelopeId_idx" ON "Field"("envelopeId");

-- CreateIndex
CREATE INDEX "Recipient_envelopeId_idx" ON "Recipient"("envelopeId");

-- CreateIndex
CREATE UNIQUE INDEX "Recipient_envelopeId_email_key" ON "Recipient"("envelopeId", "email");

-- CreateIndex
CREATE UNIQUE INDEX "TemplateDirectLink_envelopeId_key" ON "TemplateDirectLink"("envelopeId");

-- AddForeignKey
ALTER TABLE "Envelope" ADD CONSTRAINT "Envelope_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Envelope" ADD CONSTRAINT "Envelope_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Envelope" ADD CONSTRAINT "Envelope_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "Folder"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Envelope" ADD CONSTRAINT "Envelope_documentMetaId_fkey" FOREIGN KEY ("documentMetaId") REFERENCES "DocumentMeta"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvelopeItem" ADD CONSTRAINT "EnvelopeItem_documentDataId_fkey" FOREIGN KEY ("documentDataId") REFERENCES "DocumentData"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvelopeItem" ADD CONSTRAINT "EnvelopeItem_envelopeId_fkey" FOREIGN KEY ("envelopeId") REFERENCES "Envelope"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentAuditLog" ADD CONSTRAINT "DocumentAuditLog_envelopeId_fkey" FOREIGN KEY ("envelopeId") REFERENCES "Envelope"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Recipient" ADD CONSTRAINT "Recipient_envelopeId_fkey" FOREIGN KEY ("envelopeId") REFERENCES "Envelope"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Field" ADD CONSTRAINT "Field_envelopeItemId_fkey" FOREIGN KEY ("envelopeItemId") REFERENCES "EnvelopeItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Field" ADD CONSTRAINT "Field_envelopeId_fkey" FOREIGN KEY ("envelopeId") REFERENCES "Envelope"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentShareLink" ADD CONSTRAINT "DocumentShareLink_envelopeId_fkey" FOREIGN KEY ("envelopeId") REFERENCES "Envelope"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TemplateDirectLink" ADD CONSTRAINT "TemplateDirectLink_envelopeId_fkey" FOREIGN KEY ("envelopeId") REFERENCES "Envelope"("id") ON DELETE CASCADE ON UPDATE CASCADE;
