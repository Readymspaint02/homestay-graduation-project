const DEFAULT_API_PORT = (import.meta.env.VITE_API_PORT as string) || '8083'

const resolveDefaultApiBase = () => {
  if (typeof window === 'undefined') {
    return `http://127.0.0.1:${DEFAULT_API_PORT}`
  }
  return ''
}

const BASE_URL = (import.meta.env.VITE_API_BASE_URL as string) || resolveDefaultApiBase()

// Default sys_client.client_id from ry_vue_5.X.sql (client_key = pc)
const RUOYI_CLIENT_ID = 'e5cd7e4891bf95d1d19206ce24a7b32e'

const USER_ID = 'user_id'
const USER_NAME = 'user_name'
const USER_TOKEN = 'user_token'

const ADMIN_USER_ID = 'admin_user_id'
const ADMIN_USER_NAME = 'admin_user_name'
const ADMIN_USER_TOKEN = 'admin_user_token'


export { BASE_URL, RUOYI_CLIENT_ID, USER_TOKEN, USER_NAME, USER_ID, ADMIN_USER_ID, ADMIN_USER_NAME, ADMIN_USER_TOKEN }
