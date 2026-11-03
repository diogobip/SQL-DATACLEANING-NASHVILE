--Cleaning Data in SQL Queries

select * from Nashvile --ProjectTable

--Standartize Sale Date

select Saledateconverted,convert(date,saledate)
from Nashvile

update Nashvile
set saledate = convert(date,saledate)

ALTER TABLE Nashvile
Add Saledateconverted DATE;

update Nashvile
set Saledateconverted = convert(date,saledate)

--Populate Property Adress Data

select *
from Nashvile
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.propertyaddress,b.propertyAddress)
from Nashvile a
Join Nashvile b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.propertyaddress,b.propertyAddress)
from Nashvile a
Join Nashvile b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

-- Breaking out Address into individual Columns(Address,City,State)

select PropertyAddress
from Nashvile

select 
SUBSTRING(Propertyaddress,1, CHARINDEX(',',propertyaddress) -1) as Address
, SUBSTRING(Propertyaddress, CHARINDEX(',',propertyaddress) +1,len(PropertyAddress)) as Address
from Nashvile	

Alter Table Nashvile
add PropertysplitAddress nvarchar(255)

Update Nashvile
set PropertysplitAddress = SUBSTRING(Propertyaddress,1, CHARINDEX(',',propertyaddress) -1)

alter table nashvile
Add PropertysplitCity nvarchar(255)

Update Nashvile
set PropertysplitCity = SUBSTRING(Propertyaddress, CHARINDEX(',',propertyaddress) +1,len(PropertyAddress)) 

select * from Nashvile

select OwnerAddress from Nashvile

select 
PARSENAME(replace(OwnerAddress,',','.') ,3),
PARSENAME(replace(OwnerAddress,',','.') ,2),
PARSENAME(replace(OwnerAddress,',','.') ,1)
from Nashvile

Alter Table Nashvile
add Ownersplitaddress nvarchar(255)

Update Nashvile
set OwnersplitAddress = PARSENAME(replace(OwnerAddress,',','.') ,3)

alter table nashvile
Add OwnersplitCity nvarchar(255)

Update Nashvile
set OwnersplitCity = PARSENAME(replace(OwnerAddress,',','.') ,2)

alter table nashvile
Add OwnersplitState nvarchar(255)

Update Nashvile
set OwnersplitState = PARSENAME(replace(OwnerAddress,',','.') ,1)

--Change Y and N to Yes and No in "Sold as vacant" field

select distinct SoldAsVacant,count(SoldAsVacant)
from Nashvile
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from Nashvile

Update Nashvile
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end

-- Remove Duplicates
with rownumCTE as(
Select *,
	ROW_NUMBER() over(
	Partition by parcelid,
	propertyaddress,
	saleprice,
	saledate,
	legalreference
	order by 
		uniqueid) row_num
from Nashvile
--order by ParcelID
)
--delete 
select * 
from rownumCTE
where row_num > 1
--order by PropertyAddress

select *
from Nashvile

-- Delete Unused Columns

select *
from Nashvile

alter table Nashvile
drop column owneraddress,taxdistrict,propertyaddress

alter table Nashvile
drop column saledate

