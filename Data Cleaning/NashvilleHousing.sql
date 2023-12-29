/*

PROJECT: DATA CLEANING - NASHVILLE HOUSING
Objective: transform and clean data
*/

-- 1. Standardize date format

update NashvilleHousing
set SaleDate = CONVERT(date, SaleDate)

-- 2. Fill Property Address data where it is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject1..NashvilleHousing a
join PortfolioProject1..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject1..NashvilleHousing a
join PortfolioProject1..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- 3. Breaking down Address into smaller details (Address, City, State)
  
--- For PROPERTY ADDRESS:
Select
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1), 
Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 
from PortfolioProject1..NashvilleHousing

--- add column for Split address
alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


--- add column for Split city
alter table NashvilleHousing
add PropertySplitCity nvarchar(255)

update NashvilleHousing
set PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


--- For OWNER ADDRESS:
select 
parsename(replace(OwnerAddress, ',', '.'), 3), -- parsename function delimits substrings backward, hence 1st substring is 3rd
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject1..NashvilleHousing
where OwnerAddress is not null

--- add columns for each substrings
--- Note: this is just for representation purpose. Ideally, all alter/update functions are grouped and executed together
alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'), 2)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255)

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 1)

-- 4. Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject1..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
	case 
	when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	else SoldAsVacant
	end
from PortfolioProject1..NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = 
	case 
	when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	else SoldAsVacant
	end

-- 5. Remove duplicates
  
With RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) as row_num			
from PortfolioProject1..NashvilleHousing
)
DELETE
from RowNumCTE
where row_num > 1

With RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) as row_num			
from PortfolioProject1..NashvilleHousing
)
select *
from RowNumCTE
where row_num > 1

-- 6. Delete unused columns

alter table PortfolioProject1..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

select *
from PortfolioProject1..NashvilleHousing
