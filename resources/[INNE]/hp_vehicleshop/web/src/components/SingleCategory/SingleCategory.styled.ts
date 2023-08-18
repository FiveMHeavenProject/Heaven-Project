import { styled } from "styled-components";



export const CategoryWrapper = styled.div`
    display: flex;
    flex-direction: column;
    gap: 7px;
    position: absolute;
    left: 50px;
    top: 50%;
    transform: translateY(-45%);
    height: 70%;
    min-width: 20%;
    padding-right: 7px;
    overflow-y: auto;

    &::-webkit-scrollbar {
        width: 10px; 
        background-color: rgba(0,0,0,0.7);   
    }
    &::-webkit-scrollbar-thumb {
        background-color:#fd4370;
        /* box-shadow: 0px 0px 10px 0px #fd4370; */
    }
    
`;

export const CategoryItem = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px;
    cursor: pointer;
    background-color: rgba(0,0,0,0.7);
    transition: box-shadow .2s;
`;

export const ItemTextLeft = styled.div`
   display: flex;
   flex-direction: column;
   gap: 2px;
`;



export const ItemModel = styled.p`
   color: #fd4370;
   font-size: 20px;
   text-transform: uppercase;
   font-weight: 900;
`;

export const ItemBrand = styled.p`
   color: #aaa;
   font-size: 12px;
   text-transform: uppercase;
   font-weight: 500;
`;


export const ItemPrice = styled.p`
   color: white;
   font-weight: 700;
   font-size: 20px;
   text-transform: uppercase;
`;

