import { useEffect, useState } from 'react';
import * as S from './CarCategories.styled.ts';
import { faArrowRight } from '@fortawesome/free-solid-svg-icons';
import { faArrowLeft} from '@fortawesome/free-solid-svg-icons';

interface ICarCategoriesProps {
  setCategory:React.Dispatch<React.SetStateAction<string>>;
  allCategories:string[];
}

const CarCategories = ({setCategory, allCategories}: ICarCategoriesProps) => {

  const [selectedCategoryIndex, setSelectedCategoryIndex] = useState(0);

  
  useEffect(() => {
    setCategory(allCategories[selectedCategoryIndex])
  }, [selectedCategoryIndex])


  const handleChangeCategory = (direction: string) => {
    if(direction === "left") {
      setSelectedCategoryIndex(prevIndex => (prevIndex - 1 + allCategories.length) % allCategories.length);
    } else {
      setSelectedCategoryIndex(prevIndex => (prevIndex + 1) % allCategories.length);
    }
  }

  return (
   <S.CategoriesWrapper>
    <S.CategoryArrow position="left" onClick={() => handleChangeCategory("left")} icon={faArrowLeft} />
    <S.CategoryTitle>{allCategories[selectedCategoryIndex]}</S.CategoryTitle>
    <S.CategoryArrow position="right" onClick={() => handleChangeCategory("right")} icon={faArrowRight} />
   </S.CategoriesWrapper>
  )
}

export default CarCategories