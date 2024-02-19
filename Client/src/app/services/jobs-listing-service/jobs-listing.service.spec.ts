import { TestBed } from '@angular/core/testing';

import { JobsListingService } from './jobs-listing.service';

describe('JobsListingService', () => {
  let service: JobsListingService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(JobsListingService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
