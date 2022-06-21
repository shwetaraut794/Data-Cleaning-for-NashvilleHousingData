--Query to check null values in PropertyAddress

select * from [NashvilleHousingData]
--where propertyaddress is null;

--Query to find out what could be the possible value of propertyAddress instead of null
 select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress from NashvilleHousingData a
 join NashvilleHousingData b
 on a.ParcelID = b.ParcelID
 where a.[UniqueID ] <> b.[UniqueID ]

 select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress from NashvilleHousingData a
 join NashvilleHousingData b
 on a.ParcelID = b.ParcelID
 where a.[UniqueID ] <> b.[UniqueID ]
 and a.propertyaddress is null


 select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
 from NashvilleHousingData a
 join NashvilleHousingData b
 on a.ParcelID = b.ParcelID
 where a.[UniqueID ] <> b.[UniqueID ]
 and a.propertyaddress is null


 --Query to update PropertyAddress

 update a
 set a.propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
 from NashvilleHousingData a
 join NashvilleHousingData b
 on a.ParcelID = b.ParcelID
 where a.[UniqueID ] <> b.[UniqueID ]
 and a.propertyaddress is null



 --Query to seperate address and city from property address

 select 
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1),
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1,(LEN(PropertyAddress)))
 from
 NashvilleHousingData

--Query to create new columns for splitted address
 alter table NashvilleHousingData
 add City VARCHAR(50);
 alter table NashvilleHousingData
 add Address VARCHAR(225);

--Query to Update newly created columns for splitted address
 update NashvilleHousingData
 set City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1,(LEN(PropertyAddress)))

 update NashvilleHousingData
 set Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)



--Query for splitting ownerAddress
 select PARSENAME(replace(OwnerAddress,',','.'),3),
 PARSENAME(replace(OwnerAddress,',','.'),2),
 PARSENAME(replace(OwnerAddress,',','.'),1)
 from NashvilleHousingData

--Query to create new columns for splitted address
 alter table NashvilleHousingData
 add OwnerSplittedAddress VARCHAR(225);

 alter table NashvilleHousingData
 add OwnerCity VARCHAR(225);

 alter table NashvilleHousingData
 add OwnerState VARCHAR(225);
--Query to update newly created columns
update NashvilleHousingData
 set OwnerSplittedAddress = PARSENAME(replace(OwnerAddress,',','.'),3);

update NashvilleHousingData
 set OwnerCity = PARSENAME(replace(OwnerAddress,',','.'),2);

update NashvilleHousingData
 set OwnerState = PARSENAME(replace(OwnerAddress,',','.'),1);
 
select distinct(SoldAsVacant) 
from NashvilleHousingData


--Query to change data type of column name SoldAsVacant as we ae inserting 'Yes','No' in place of int values
alter table NashvilleHousingData
alter column SoldAsVacant VARCHAR(10);

--Query to update Yes or No in SoldAsVacant column
select SoldAsVacant
,CASE when SoldAsVacant = 0 THEN 'No'
	 when SoldAsVacant = 1 THEN 'Yes'
	 END
from NashvilleHousingData 

Update NashvilleHousingData
SET SoldAsVacant = CASE when SoldAsVacant = 0 THEN 'No'
	 when SoldAsVacant = 1 THEN 'Yes'
	 END


select *
from NashvilleHousingData



--Query to remove duplicates(Window functions)

WITH RowNumCTE AS(
select *,
Rank() OVER (PARTITION BY PropertyAddress,
			  ParcelID,
			  SaleDate,
			  SalePrice,
			  LegalReference
			  ORDER BY [UniqueID ])
			  As RankNum
from NashvilleHousingData)
delete from RowNumCTE where RankNum = 2;


--Query to delete colmns which are duplicates and no longer used
select * from NashvilleHousingData


alter table NashvilleHousingData
drop column PropertyAddress,
			OwnerAddress

--Query to roundoff acerage to 3 decimal
select * from NashvilleHousingData

Alter table NashvilleHousingData
add UpdatedAcreage Float

update NashvilleHousingData
set UpdatedAcreage = ROUND(Acreage,3)

alter table NashvilleHousingData
drop column Acreage

			

