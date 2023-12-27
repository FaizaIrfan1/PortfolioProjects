--Cleaning Data In  SQL Queries--


Select *
From PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format

Select SaleDate, CONVERT(Date, SaleDate) 
From PortfolioProject..NashvilleHousing 

Update NashvilleHousing 
Set SaleDate = Convert(date,SaleDate) 

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted= CONVERT(date,SaleDate)



Select *
From NashvilleHousing


--Populate Property Address (Self Join)
Select a.propertyaddress,b.propertyaddress, a.parcelid, b.parcelid, ISNULL(a.propertyAddress,b.propertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing  b  On a.uniqueid<>b.uniqueid and a.parcelid=b.parcelid
where a.propertyAddress is Null

UPdate a
SET PropertyAddress= Isnull(a.propertyAddress,b.propertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing  b  On a.uniqueid<>b.uniqueid and a.parcelid=b.parcelid
where a.propertyAddress is Null



--Breaking Out Address into Individual columns--

--Using Substring


Select 
SUBSTRING (PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
Substring (PropertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress))
From PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress= SUBSTRING (PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity= Substring (PropertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

--Using ParseName


Select ParseName(replace(owneraddress,',','.'),3),
ParseName(replace(owneraddress,',','.'),2),
ParseName(replace(owneraddress,',','.'),1)
From NashvilleHousing



Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitAddress=  ParseName(replace(owneraddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity=  ParseName(replace(owneraddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState=  ParseName(replace(owneraddress,',','.'),1)


Select *
From NashvilleHousing


--Chane Y to YES and N to NO in SoldASVacant field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant
Order By  2


Select SoldAsVacant,
Case
    When SoldAsVacant='Y' Then 'Yes'
	When SoldAsVacant='N' Then 'No'
	Else SoldAsVacant
End
From NashvilleHousing



Update NashvilleHousing
Set SoldAsVacant=Case
    When SoldAsVacant='Y' Then 'Yes'
	When SoldAsVacant='N' Then 'No'
	Else SoldAsVacant
End
From NashvilleHousing


--Removing Duplicates

With RowNumCTE As (
Select *,
ROW_NUMBER() OVER (
Partition By ParcelID,
			 PropertyAddress,
			 SaleDate,
			 SalePrice,
			 LegalReference			 
Order By UniqueID)
As Row_num
From NashvilleHousing
)
Delete
From RowNumCTE
Where Row_num >1
--Order by PropertyAddress



--Delete Unsused Columns


Select *
From NashvilleHousing


Alter Table NashvilleHousing
Drop Column PropertyAddress,SaleDate,TaxDistrict, OwnerAddress