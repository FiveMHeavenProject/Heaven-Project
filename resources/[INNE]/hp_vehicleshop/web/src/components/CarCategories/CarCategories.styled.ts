import { styled } from "styled-components";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';


export const CategoriesWrapper = styled.div`
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 100px;
    width: 100%;
    height: 10vh;
    background-color: rgba(0,0,0,0.7);
`;


export const CategoryTitle = styled.h1`
    font-size: 40px;
    font-weight: 900;
    color: white;
    text-transform: uppercase;
    text-shadow: 0px 0px 10px #fd4370;
`;


export const CategoryArrow = styled(FontAwesomeIcon)<{position: string}>`
    color: white;
    font-size: 2rem;
    cursor: pointer;
    padding: 15px;
    position: absolute;
    ${(props) => props.position}: 25%;
`;