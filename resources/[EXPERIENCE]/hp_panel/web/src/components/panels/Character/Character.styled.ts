import { styled } from "styled-components";

export const Wrapper = styled.div`
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-gap: 20px;
`

export const PanelElement = styled.div<{ span: number }>`
    display: grid;
    grid-auto-flow: column;
    background-color: rgba(0, 0, 0, 0.25);
    padding: 20px;
    border-radius: 10px;
    height: 100%;
    grid-column: span ${(props) => props.span};
`;

export const PanelElementBox = styled.div`
    display: flex;
    flex-direction: column
`;

export const PanelElementBoxLabel = styled.div`
    font-size: 24px;
    font-weight: 500;
    margin-bottom: 10px;
`;

export const PanelElementBoxValue = styled.div`
    font-size: 36px;
    font-weight: 600;
    color: #00b2ff;
`;
