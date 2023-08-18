import { styled } from "styled-components";

export const Wrapper = styled.div`
    display: flex;
    flex-direction: column;
    gap: 20px;
    width: 100%;
`;

export const Grid = styled.div`
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-gap: 20px;
    width: 100%;
`

export const GridItem = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    gap: 10px;
    padding: 20px;
    background-color: rgba(0, 0, 0, 0.25);
    border-radius: 10px;
    height: 200px;
`;

export const PlaceAndPoints = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    width: 100%;
    margin-bottom: 10px;
`

export const Place = styled.img`
    width: 70px;
    height: 70px;
    object-fit: contain;
`

export const Points = styled.p`
    font-size: 24px;
`

export const Name = styled.p`
    font-size: 28px;
    font-weight: 600;
`

export const List = styled.ul`
    display: flex;
    flex-direction: column;
    gap: 10px;
    width: 100%;
`

export const ListItem = styled.li`
    display: flex;
    align-items: center;
    gap: 10px;
    width: 100%;
    background-color: rgba(0, 0, 0, 0.25);
    padding: 10px 20px;
    border-radius: 10px;
`

export const ListPlace = styled.p`
    font-size: 24px;
    font-weight: 600;
    width: 60px;
`;

export const ListPoints = styled.p`
    font-size: 20px;
    font-weight: 400;
    width: calc(50% - 60px);
`;

export const ListName = styled.p`
    font-size: 20px;
    font-weight: 400;
    width: 50%;
`;