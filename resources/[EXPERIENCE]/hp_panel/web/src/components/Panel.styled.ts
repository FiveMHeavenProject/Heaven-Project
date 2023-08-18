import styled from 'styled-components';
import { IconX } from '@tabler/icons-react';

export const PanelWrapper = styled.div`
    width: 100%;
    height: 100%;
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    top: 50px;
    left: 50px;
    width: calc(100% - 100px);
    height: calc(100% - 100px);
`;

export const Panel = styled.div`
    width: 1200px;
    height: 800px;
    background-color: rgba(0, 0, 0, 0.5);
    padding: 30px;
    margin: 50px;
    color: white;
    font-size: 20px;
    display: flex;
    flex-direction: column;
    border-radius: 20px;
`;

export const PanelHeader = styled.div`
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
`;

export const PanelTitle = styled.div`
    font-size: 32px;
    font-weight: 500;
`;

export const CloseButton = styled(IconX)`
    color: white;
    cursor: pointer;
    &:hover {
        color: rgba(255, 255, 255, 0.75);
    }
`;

export const PanelBody = styled.div`
    display: flex;
    flex-direction: column;
    gap: 20px;
    height: 100%;
    overflow-y: auto;
    padding-right: 20px;
    margin-right: -20px;
    &::-webkit-scrollbar {
        width: 10px;
    }
    &::-webkit-scrollbar-track {
        background: transparent;
    }
    &::-webkit-scrollbar-thumb {
        background: rgba(255, 255, 255, 0.2);
        border-radius: 10px;
    }
    &::-webkit-scrollbar-thumb:hover {
        background: rgba(255, 255, 255, 0.3);
    }
`;
