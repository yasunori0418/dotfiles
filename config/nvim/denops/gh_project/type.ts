export type GHProject = {
  closed: boolean,
  fields: {
    totalCount: number
  },
  id: string,
  items: {
    totalCount: number,
  },
  number: number,
  owner: {
    login: string,
    type: string
  },
  public: boolean,
  readme: string,
  shortDescription: string,
  title: string,
  url: string
};
