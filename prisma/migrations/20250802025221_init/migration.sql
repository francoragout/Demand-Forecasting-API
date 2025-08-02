-- CreateEnum
CREATE TYPE "public"."Role" AS ENUM ('ADMIN', 'USER');

-- CreateTable
CREATE TABLE "public"."User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "public"."Role" NOT NULL DEFAULT 'USER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastLogin" TIMESTAMP(3),

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."RefreshToken" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RefreshToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."SalesData" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "sku" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "quantity" INTEGER NOT NULL,
    "price" DECIMAL(10,4) NOT NULL,
    "promotion" BOOLEAN NOT NULL,
    "category" TEXT NOT NULL,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fileName" TEXT NOT NULL,
    "dataVersion" INTEGER NOT NULL,

    CONSTRAINT "SalesData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Forecast" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "sku" TEXT NOT NULL,
    "forecastDate" TIMESTAMP(3) NOT NULL,
    "baseValue" INTEGER NOT NULL,
    "upperBound" INTEGER NOT NULL,
    "lowerBound" INTEGER NOT NULL,
    "confidenceLevel" DOUBLE PRECISION NOT NULL,
    "seasonalFactor" DOUBLE PRECISION,
    "trendComponent" DOUBLE PRECISION,
    "dataQualityScore" DOUBLE PRECISION,
    "generatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modelVersion" TEXT NOT NULL,

    CONSTRAINT "Forecast_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Configuration" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "confidenceLevel" DOUBLE PRECISION NOT NULL DEFAULT 0.95,
    "forecastHorizon" INTEGER NOT NULL DEFAULT 3,
    "alertThresholds" JSONB,
    "notificationSettings" JSONB,

    CONSTRAINT "Configuration_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "RefreshToken_token_key" ON "public"."RefreshToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "Configuration_userId_key" ON "public"."Configuration"("userId");

-- AddForeignKey
ALTER TABLE "public"."RefreshToken" ADD CONSTRAINT "RefreshToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."SalesData" ADD CONSTRAINT "SalesData_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Forecast" ADD CONSTRAINT "Forecast_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Configuration" ADD CONSTRAINT "Configuration_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
