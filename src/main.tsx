import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import './index.css'
import logo from '/Users/abhishekkumar/batched-gasless/vite-project/public/logo.svg';

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
   <div>
      <img src={logo} alt="logo" style={{ width: '60px', height: '60px'}}/> 

      <h2 style={{fontFamily:"sans-serif",paddingBottom:"20px", fontSize:"40px"}}>Batched transactions with Biconomy SDK</h2>

      <h2 style={{fontFamily:"sans-serif"}}>Mint and Transfer NFTs as Batched Transaction</h2>
    
<br></br>
      <App />
      <h2 style={{paddingTop:'250px',fontFamily:"monospace"}}>Built with Biconomy SDK</h2>
    </div>
  </React.StrictMode>,
)
