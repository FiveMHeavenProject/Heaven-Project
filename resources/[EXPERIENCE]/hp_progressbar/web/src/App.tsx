import { useEffect, useState } from 'react';
import { ProgressbarDataType } from './types/ProgressbarTypes';
import Progressbar from './components/Progressbar';

function App() {
  // debug
  const [isDev, setIsDev] = useState(false);
  const [devProgressbar, setDevProgressbar] = useState<ProgressbarDataType>({
    label: 'test',
    time: 10000,
    textColor: '#ff7700',
    bgColor: '#00d9ff',
  });
  const [progressbar, setProgressbar] = useState<ProgressbarDataType>();
  const [isProgressbarOpen, setIsProgressbarOpen] = useState(false);

  const env = process.env.NODE_ENV || 'development';

  useEffect(() => {
    if (env === 'development') {
      setIsDev(true);
    }
  }, [env]);

  const openProgressbar = (data: {
    message: string,
    length: number,
    textcolor: string,
    bgcolor: string,
  }) => {
    setProgressbar({
      label: data.message,
      time: data.length,
      textColor: data.textcolor || '#ffffff',
      bgColor: data.bgcolor || '#0066ff',
    });
    setIsProgressbarOpen(true);
  };

  const devShowProgressbar = () => {
    setProgressbar(devProgressbar);
    setIsProgressbarOpen(true);
  };

  const closeProgressbar = () => {
    setIsProgressbarOpen(false);

    fetch(`https://hp_progressbar/close`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({})
    }).then(resp => resp.json());
  };

  window.addEventListener('message', (event) => {
    if (event.data.type === 'startProgress') {
      openProgressbar(event.data);
    }
    if (event.data.type === 'close') {
      closeProgressbar();
    }
  });

  window.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      closeProgressbar();
    }
  });

  return (
    <>
      {isDev ? (
        <div style={{
          display: 'flex',
          flexDirection: 'column',
          width: '150px'
        }}>
          <input
            onChange={e => setDevProgressbar({ ...devProgressbar, label: e.target.value, })}
            type="text" placeholder='label' defaultValue={devProgressbar.label} />
          <input
            onChange={e => setDevProgressbar({ ...devProgressbar, time: Number(e.target.value) })}
            type="number" placeholder='time' defaultValue={devProgressbar.time} />
          <input
            onChange={e => setDevProgressbar({ ...devProgressbar, textColor: e.target.value })}
            type="color" placeholder='textColor' defaultValue={devProgressbar.textColor} />
          <input
            onChange={e => setDevProgressbar({ ...devProgressbar, bgColor: e.target.value })}
            type="color" placeholder='bgColor' defaultValue={devProgressbar.bgColor} />
          <button onClick={devShowProgressbar}>Show progressbar</button>
          <button onClick={closeProgressbar}>Close progressbar</button>
        </div>
      ) : null}
      {(isProgressbarOpen && progressbar) ? <Progressbar data={progressbar} closeProgressbar={closeProgressbar} /> : null}
    </>
  )
}

export default App
