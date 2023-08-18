import { useEffect, useState } from 'react';
import { Panel } from './components/Panel'
import { setMockData } from './helpers/setMockData';
import { JobLeaderboardType } from './types/JobLeaderboardTypes';
import { CharacterType } from './types/CharacterTypes';

function App() {
  // debug
  const [isDev, setIsDev] = useState(false);
  const [selectedDevPanel, setSelectedDevPanel] = useState<string>('character');

  const [isOpen, setIsOpen] = useState(false);
  const [panelName, setPanelName] = useState<string>('');
  const [data, setData] = useState<{
    character?: CharacterType
    jobLeaderboard?: JobLeaderboardType
  }>({});

  const env = process.env.NODE_ENV || 'development';

  useEffect(() => {
    if (env === 'development') {
      setIsDev(true);
      setMockData(setData);
    }
  }, [env]);


  window.addEventListener('message', (event) => {
    if (event.data.type === 'open-char-panel') {
      setIsOpen(true);
      setPanelName('character');
      setData({ ...data, character: event.data.pInfo });
    } else if (event.data.type === 'open-job-panel') {
      setIsOpen(true);
      setPanelName('job-leaderboard');
      setData({ ...data, jobLeaderboard: event.data.leaderboard });
    }
  });

  // on escape key press
  window.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      setIsOpen(false);
      close();
    }
  });

  const close = () => {
    setIsOpen(false);

    fetch(`https://hp_panel/close`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({})
    });
  }

  const openPanelInDev = () => {
    setIsOpen(true);
    setPanelName(selectedDevPanel);
  }

  return (
    <>
      {isDev ? (
        <>
          <select onChange={(e) => setSelectedDevPanel(e.target.value)}>
            <option value="character">character</option>
            <option value="job-leaderboard">job-leaderboard</option>
          </select>
          <button onClick={openPanelInDev}>Open panel</button>
        </>
      ) : null}
      {isOpen ? <Panel close={close} data={data} panelName={panelName} /> : null}
    </>
  )
}

export default App
