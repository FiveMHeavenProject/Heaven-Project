import { styled } from "styled-components";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";



export const ItemListContainer = styled.div`
    display: flex;
    flex-direction: column;
    flex: 2.5;
    background-color: rgba(0,0,0,0.7);
`;



export const Heading = styled.h1`
    display: flex;
    gap: 7px;
    font-size: 40px;
    text-transform: uppercase;
    font-weight: 700;
    border-bottom: 2px solid white;
    padding:25px;
`;

export const ShopIcon = styled(FontAwesomeIcon)`
    color: white;
    font-size: 40px;
`;

export const ProductsContainer = styled.div`
    flex-grow: 1;
    min-height: 0;
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    grid-template-rows: repeat(3, 1fr);
    gap: 15px;
    margin-top: 25px;
    padding-inline:25px;
    overflow-y: auto; 
    max-height: 100%;

    &::-webkit-scrollbar {
        display: none;
    }

`;


export const Product = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: flex-start;
    gap: 5px;
    background-color: rgba(0,0,0,0.65);
    padding: 10px;
    

    & img {
        align-self: center ;
        width:100px;
    }
`;

export const ProductInfo = styled.div`
display: flex;
justify-content: space-between;
align-items: center;
width: 100%;
`;

export const ProductName = styled.p`
text-transform: capitalize;
font-size: 20px;
text-align: center;
font-weight: 500;
padding: 6px;
`;

export const ProductWeight = styled.p`
color: #777;
font-size: 16px;
text-align: center;
font-weight: 500;
padding: 6px;
`;

export const ProductPrice = styled.p`
text-transform: capitalize;
font-size: 20px;
text-align: center;
font-weight: 500;
display: flex;
gap: 1px;
padding: 6px;
`;

export const ProductBtn = styled(FontAwesomeIcon)`
background-color: rgba(253,67,112,.65);
font-size: 18px;
cursor: pointer;
padding: 6px;
transition: background .2s;
width: 50px;
`;


