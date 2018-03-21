/* global localStorage */
import axios from 'axios'

const API_URL = process.env.API_URL || 'http://localhost:3000/system_user_manager'

export default axios.create({
  baseURL: API_URL,
  headers: {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + localStorage.token
  }
})
